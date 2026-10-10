package com.rytmavo.rytmavo.wear

import android.app.PendingIntent
import android.content.Intent
import androidx.wear.watchface.complications.data.ComplicationData
import androidx.wear.watchface.complications.data.ComplicationType
import androidx.wear.watchface.complications.data.LongTextComplicationData
import androidx.wear.watchface.complications.data.NoDataComplicationData
import androidx.wear.watchface.complications.data.PlainComplicationText
import androidx.wear.watchface.complications.data.ShortTextComplicationData
import androidx.wear.watchface.complications.datasource.ComplicationRequest
import androidx.wear.watchface.complications.datasource.SuspendingComplicationDataSourceService
import java.time.LocalDate

/** Watch face complication: today's shift (short) or name + times (long). */
class ShiftComplicationService : SuspendingComplicationDataSourceService() {
    override suspend fun onComplicationRequest(request: ComplicationRequest): ComplicationData? {
        val day = SnapshotStore.load(this)?.dayOn(LocalDate.now())
            ?: return NoDataComplicationData()
        val name = if (day.hasShift) day.name else getString(R.string.no_entry)
        return build(request.complicationType, day.takeIf { it.hasShift }?.abbr ?: "–", name, day.start, day.timeRange)
    }

    override fun getPreviewData(type: ComplicationType): ComplicationData? =
        build(type, "F", "Früh", "06:00", "06:00–14:00")

    private fun build(
        type: ComplicationType,
        abbr: String,
        name: String,
        start: String?,
        timeRange: String?,
    ): ComplicationData? {
        val description = plain(listOfNotNull(getString(R.string.today), name, timeRange).joinToString(", "))
        return when (type) {
            ComplicationType.SHORT_TEXT ->
                ShortTextComplicationData.Builder(plain(abbr), description)
                    .apply { start?.let { setTitle(plain(it)) } }
                    .setTapAction(openApp())
                    .build()
            ComplicationType.LONG_TEXT ->
                LongTextComplicationData.Builder(plain(listOfNotNull(name, timeRange).joinToString(" ")), description)
                    .setTitle(plain(getString(R.string.today)))
                    .setTapAction(openApp())
                    .build()
            else -> null
        }
    }

    private fun plain(text: String) = PlainComplicationText.Builder(text).build()

    private fun openApp(): PendingIntent = PendingIntent.getActivity(
        this,
        0,
        Intent(this, MainActivity::class.java),
        PendingIntent.FLAG_IMMUTABLE,
    )
}
