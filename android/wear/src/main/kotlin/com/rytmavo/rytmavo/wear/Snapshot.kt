package com.rytmavo.rytmavo.wear

import android.content.ComponentName
import android.content.Context
import androidx.wear.tiles.TileService
import androidx.wear.watchface.complications.datasource.ComplicationDataSourceUpdateRequester
import java.time.LocalDate
import org.json.JSONObject

/**
 * One day as sent by the phone. Mirrors
 * lib/features/watch/domain/entities/watch_snapshot.dart; names are already
 * localized on the phone.
 */
data class WatchDay(
    val date: LocalDate,
    val kind: String,
    val name: String,
    val abbr: String,
    val color: Int?,
    val start: String?,
    val end: String?,
    val isOverride: Boolean,
) {
    val hasShift: Boolean get() = kind != "none"
    val isOff: Boolean get() = kind == "off"
    val timeRange: String? get() = if (start != null && end != null) "$start–$end" else null
}

data class WatchSnapshot(val days: List<WatchDay>) {
    fun dayOn(date: LocalDate): WatchDay? = days.firstOrNull { it.date == date }

    fun daysFrom(date: LocalDate): List<WatchDay> = days.filter { !it.date.isBefore(date) }

    fun nextWorkDayAfter(date: LocalDate): WatchDay? =
        days.firstOrNull { it.date.isAfter(date) && it.hasShift && !it.isOff }

    companion object {
        private const val SUPPORTED_VERSION = 1

        fun parse(json: String): WatchSnapshot? = runCatching {
            val root = JSONObject(json)
            if (root.optInt("v") > SUPPORTED_VERSION) return null
            val array = root.getJSONArray("days")
            WatchSnapshot(
                (0 until array.length()).map { i ->
                    val d = array.getJSONObject(i)
                    WatchDay(
                        date = LocalDate.parse(d.getString("date")),
                        kind = d.getString("kind"),
                        name = d.optString("name"),
                        abbr = d.optString("abbr"),
                        color = if (d.isNull("color")) null else d.optLong("color").toInt(),
                        start = d.optStringOrNull("start"),
                        end = d.optStringOrNull("end"),
                        isOverride = d.optBoolean("override"),
                    )
                },
            )
        }.getOrNull()

        private fun JSONObject.optStringOrNull(key: String): String? =
            if (isNull(key)) null else optString(key)
    }
}

/** Latest snapshot on the watch, shared by the app, tile and complication. */
object SnapshotStore {
    private const val PREFS = "rytmavo_watch"
    private const val KEY = "snapshot"

    // Shared with the phone side (MainActivity.kt).
    const val DATA_PATH = "/rytmavo/snapshot"
    const val DATA_KEY = "json"

    fun load(context: Context): WatchSnapshot? =
        prefs(context).getString(KEY, null)?.let(WatchSnapshot::parse)

    /** Stores [json] and refreshes tile and complication if it is valid. */
    fun save(context: Context, json: String) {
        if (WatchSnapshot.parse(json) == null) return
        prefs(context).edit().putString(KEY, json).apply()
        TileService.getUpdater(context).requestUpdate(ShiftTileService::class.java)
        ComplicationDataSourceUpdateRequester.create(
            context,
            ComponentName(context, ShiftComplicationService::class.java),
        ).requestUpdateAll()
    }

    fun prefs(context: Context) = context.getSharedPreferences(PREFS, Context.MODE_PRIVATE)
}
