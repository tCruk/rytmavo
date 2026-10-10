package com.rytmavo.rytmavo.wear

import androidx.wear.protolayout.ActionBuilders
import androidx.wear.protolayout.ColorBuilders.argb
import androidx.wear.protolayout.DimensionBuilders.dp
import androidx.wear.protolayout.DimensionBuilders.expand
import androidx.wear.protolayout.DimensionBuilders.sp
import androidx.wear.protolayout.LayoutElementBuilders
import androidx.wear.protolayout.ModifiersBuilders
import androidx.wear.protolayout.ResourceBuilders
import androidx.wear.protolayout.TimelineBuilders
import androidx.wear.tiles.RequestBuilders
import androidx.wear.tiles.TileBuilders
import androidx.wear.tiles.TileService
import com.google.common.util.concurrent.Futures
import com.google.common.util.concurrent.ListenableFuture
import java.time.LocalDate
import java.time.ZoneId

/**
 * Tile with today's shift and the next work shift. Holds one timeline entry
 * per day of the snapshot, so it flips at midnight without the phone.
 */
class ShiftTileService : TileService() {
    override fun onTileRequest(
        requestParams: RequestBuilders.TileRequest,
    ): ListenableFuture<TileBuilders.Tile> {
        val snapshot = SnapshotStore.load(this)
        val timeline = TimelineBuilders.Timeline.Builder()
        // Fallback without validity: shown once all days have passed.
        timeline.addTimelineEntry(entry(layoutFor(null, null)))
        val zone = ZoneId.systemDefault()
        snapshot?.daysFrom(LocalDate.now())?.forEach { day ->
            val start = day.date.atStartOfDay(zone).toInstant().toEpochMilli()
            val end = day.date.plusDays(1).atStartOfDay(zone).toInstant().toEpochMilli()
            val validity = TimelineBuilders.TimeInterval.Builder()
                .setStartMillis(start)
                .setEndMillis(end)
                .build()
            timeline.addTimelineEntry(
                entry(layoutFor(day, snapshot.nextWorkDayAfter(day.date)), validity),
            )
        }
        return Futures.immediateFuture(
            TileBuilders.Tile.Builder()
                .setResourcesVersion(RESOURCES_VERSION)
                .setTileTimeline(timeline.build())
                .build(),
        )
    }

    override fun onTileResourcesRequest(
        requestParams: RequestBuilders.ResourcesRequest,
    ): ListenableFuture<ResourceBuilders.Resources> = Futures.immediateFuture(
        ResourceBuilders.Resources.Builder().setVersion(RESOURCES_VERSION).build(),
    )

    private fun entry(
        root: LayoutElementBuilders.LayoutElement,
        validity: TimelineBuilders.TimeInterval? = null,
    ): TimelineBuilders.TimelineEntry {
        val builder = TimelineBuilders.TimelineEntry.Builder()
            .setLayout(LayoutElementBuilders.Layout.Builder().setRoot(root).build())
        validity?.let(builder::setValidity)
        return builder.build()
    }

    private fun layoutFor(day: WatchDay?, next: WatchDay?): LayoutElementBuilders.LayoutElement {
        val column = LayoutElementBuilders.Column.Builder()
            .setHorizontalAlignment(LayoutElementBuilders.HORIZONTAL_ALIGN_CENTER)
        if (day == null) {
            column.addContent(text(getString(R.string.empty), 14f, WHITE, maxLines = 4))
        } else {
            column.addContent(text(getString(R.string.today), 12f, GREY))
            column.addContent(spacer(4f))
            column.addContent(badge(day))
            column.addContent(spacer(4f))
            column.addContent(
                text(if (day.hasShift) day.name else getString(R.string.no_entry), 18f, WHITE, bold = true),
            )
            day.timeRange?.let { column.addContent(text(it, 14f, WHITE)) }
            next?.let {
                column.addContent(spacer(6f))
                column.addContent(
                    text(getString(R.string.next_shift, "${it.abbr} ${it.date.dayOfMonth}.${it.date.monthValue}."), 12f, GREY),
                )
            }
        }
        return LayoutElementBuilders.Box.Builder()
            .setWidth(expand())
            .setHeight(expand())
            .setModifiers(openAppModifier())
            .addContent(column.build())
            .build()
    }

    private fun badge(day: WatchDay): LayoutElementBuilders.LayoutElement =
        LayoutElementBuilders.Box.Builder()
            .setWidth(dp(40f))
            .setHeight(dp(40f))
            .setModifiers(
                ModifiersBuilders.Modifiers.Builder()
                    .setBackground(
                        ModifiersBuilders.Background.Builder()
                            .setColor(argb(day.color ?: DARK_GREY))
                            .setCorner(ModifiersBuilders.Corner.Builder().setRadius(dp(20f)).build())
                            .build(),
                    )
                    .build(),
            )
            .addContent(text(if (day.hasShift) day.abbr else "–", 16f, WHITE, bold = true))
            .build()

    private fun text(
        value: String,
        size: Float,
        color: Int,
        bold: Boolean = false,
        maxLines: Int = 1,
    ): LayoutElementBuilders.LayoutElement =
        LayoutElementBuilders.Text.Builder()
            .setText(value)
            .setMaxLines(maxLines)
            .setFontStyle(
                LayoutElementBuilders.FontStyle.Builder()
                    .setSize(sp(size))
                    .setColor(argb(color))
                    .setWeight(
                        if (bold) LayoutElementBuilders.FONT_WEIGHT_BOLD
                        else LayoutElementBuilders.FONT_WEIGHT_NORMAL,
                    )
                    .build(),
            )
            .build()

    private fun spacer(height: Float): LayoutElementBuilders.LayoutElement =
        LayoutElementBuilders.Spacer.Builder().setHeight(dp(height)).build()

    private fun openAppModifier(): ModifiersBuilders.Modifiers =
        ModifiersBuilders.Modifiers.Builder()
            .setClickable(
                ModifiersBuilders.Clickable.Builder()
                    .setId("open_app")
                    .setOnClick(
                        ActionBuilders.LaunchAction.Builder()
                            .setAndroidActivity(
                                ActionBuilders.AndroidActivity.Builder()
                                    .setPackageName(packageName)
                                    .setClassName(MainActivity::class.java.name)
                                    .build(),
                            )
                            .build(),
                    )
                    .build(),
            )
            .build()

    private companion object {
        const val RESOURCES_VERSION = "1"
        const val WHITE = 0xFFFFFFFF.toInt()
        const val GREY = 0xFFB0B0B0.toInt()
        const val DARK_GREY = 0xFF424242.toInt()
    }
}
