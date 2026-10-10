package com.rytmavo.rytmavo.wear

import android.content.SharedPreferences
import android.net.Uri
import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.res.stringResource
import androidx.compose.ui.semantics.clearAndSetSemantics
import androidx.compose.ui.semantics.contentDescription
import androidx.compose.ui.semantics.semantics
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextAlign
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.wear.compose.foundation.lazy.ScalingLazyColumn
import androidx.wear.compose.foundation.lazy.rememberScalingLazyListState
import androidx.wear.compose.material.ListHeader
import androidx.wear.compose.material.MaterialTheme
import androidx.wear.compose.material.PositionIndicator
import androidx.wear.compose.material.Scaffold
import androidx.wear.compose.material.Text
import androidx.wear.compose.material.TimeText
import com.google.android.gms.wearable.DataMapItem
import com.google.android.gms.wearable.Wearable
import java.time.LocalDate
import java.time.format.DateTimeFormatter
import java.time.format.FormatStyle

class MainActivity : ComponentActivity() {
    private val snapshot = mutableStateOf<WatchSnapshot?>(null)
    private val listener = SharedPreferences.OnSharedPreferenceChangeListener { _, _ ->
        snapshot.value = SnapshotStore.load(this)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        snapshot.value = SnapshotStore.load(this)
        setContent {
            MaterialTheme {
                ShiftScreen(snapshot.value, LocalDate.now())
            }
        }
    }

    override fun onStart() {
        super.onStart()
        SnapshotStore.prefs(this).registerOnSharedPreferenceChangeListener(listener)
        snapshot.value = SnapshotStore.load(this)
        fetchLatestFromDataLayer()
    }

    override fun onStop() {
        SnapshotStore.prefs(this).unregisterOnSharedPreferenceChangeListener(listener)
        super.onStop()
    }

    /** Picks up a snapshot that arrived before the app was installed. */
    private fun fetchLatestFromDataLayer() {
        Wearable.getDataClient(this)
            .getDataItems(Uri.parse("wear://*${SnapshotStore.DATA_PATH}"))
            .addOnSuccessListener { items ->
                items.forEach { item ->
                    DataMapItem.fromDataItem(item).dataMap
                        .getString(SnapshotStore.DATA_KEY)
                        ?.let { SnapshotStore.save(applicationContext, it) }
                }
                items.release()
            }
    }
}

@Composable
private fun ShiftScreen(snapshot: WatchSnapshot?, today: LocalDate) {
    val listState = rememberScalingLazyListState()
    Scaffold(
        timeText = { TimeText() },
        positionIndicator = { PositionIndicator(scalingLazyListState = listState) },
    ) {
        val todayEntry = snapshot?.dayOn(today)
        if (snapshot == null || todayEntry == null) {
            EmptyState()
            return@Scaffold
        }
        ScalingLazyColumn(state = listState, modifier = Modifier.fillMaxSize()) {
            item { TodayCard(todayEntry) }
            item { ListHeader { Text(stringResource(R.string.next_days)) } }
            snapshot.daysFrom(today).drop(1).take(6).forEach { day ->
                item { DayRow(day) }
            }
        }
    }
}

@Composable
private fun TodayCard(day: WatchDay) {
    val description = listOfNotNull(
        stringResource(R.string.today),
        day.displayName(),
        day.timeRange,
    ).joinToString(", ")
    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clearAndSetSemantics { contentDescription = description },
        horizontalAlignment = Alignment.CenterHorizontally,
    ) {
        Text(stringResource(R.string.today), color = MaterialTheme.colors.onSurfaceVariant, fontSize = 12.sp)
        ShiftBadge(day, 44.dp)
        Text(day.displayName(), fontWeight = FontWeight.SemiBold, fontSize = 18.sp)
        day.timeRange?.let { Text(it, fontSize = 14.sp) }
        if (day.isOverride) {
            Text(stringResource(R.string.changed), color = MaterialTheme.colors.onSurfaceVariant, fontSize = 11.sp)
        }
    }
}

@Composable
private fun DayRow(day: WatchDay) {
    val date = day.date.format(DateTimeFormatter.ofLocalizedDate(FormatStyle.MEDIUM))
    Row(
        modifier = Modifier
            .fillMaxWidth()
            .padding(vertical = 2.dp)
            .semantics(mergeDescendants = true) {},
        verticalAlignment = Alignment.CenterVertically,
        horizontalArrangement = Arrangement.spacedBy(8.dp),
    ) {
        ShiftBadge(day, 28.dp)
        Column(modifier = Modifier.weight(1f)) {
            Text(date, color = MaterialTheme.colors.onSurfaceVariant, fontSize = 11.sp)
            Text(day.displayName(), fontSize = 14.sp)
        }
        day.timeRange?.let { Text(it, fontSize = 11.sp) }
    }
}

/** Coloured circle with the abbreviation: meaning never relies on colour alone. */
@Composable
private fun ShiftBadge(day: WatchDay, size: Dp) {
    Box(
        modifier = Modifier
            .size(size)
            .background(day.color?.let { Color(it) } ?: Color.DarkGray, CircleShape),
        contentAlignment = Alignment.Center,
    ) {
        Text(
            if (day.hasShift) day.abbr else "–",
            color = Color.White,
            fontWeight = FontWeight.SemiBold,
            fontSize = (size.value * 0.4f).sp,
        )
    }
}

@Composable
private fun EmptyState() {
    Box(modifier = Modifier.fillMaxSize().padding(24.dp), contentAlignment = Alignment.Center) {
        Text(stringResource(R.string.empty), textAlign = TextAlign.Center, fontSize = 14.sp)
    }
}

@Composable
private fun WatchDay.displayName(): String =
    if (hasShift) name else stringResource(R.string.no_entry)
