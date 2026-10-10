package com.rytmavo.rytmavo.wear

import com.google.android.gms.wearable.DataEvent
import com.google.android.gms.wearable.DataEventBuffer
import com.google.android.gms.wearable.DataMapItem
import com.google.android.gms.wearable.WearableListenerService

/** Receives snapshots from the phone, also while the watch app is closed. */
class SnapshotListenerService : WearableListenerService() {
    override fun onDataChanged(dataEvents: DataEventBuffer) {
        for (event in dataEvents) {
            if (event.type != DataEvent.TYPE_CHANGED) continue
            val item = event.dataItem
            if (item.uri.path != SnapshotStore.DATA_PATH) continue
            val json = DataMapItem.fromDataItem(item).dataMap.getString(SnapshotStore.DATA_KEY)
            if (json != null) SnapshotStore.save(applicationContext, json)
        }
    }
}
