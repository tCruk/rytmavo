package com.rytmavo.rytmavo

import android.util.Log
import com.google.android.gms.wearable.PutDataMapRequest
import com.google.android.gms.wearable.Wearable
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WATCH_CHANNEL)
            .setMethodCallHandler { call, result ->
                val json = call.arguments as? String
                if (call.method != "publishSnapshot" || json == null) {
                    result.notImplemented()
                    return@setMethodCallHandler
                }
                publishToWatch(json)
                result.success(null)
            }
    }

    /**
     * Hands the shift snapshot to the Wearable Data Layer. It syncs directly
     * to a paired Wear OS watch (Bluetooth/Wi-Fi), no server involved, and
     * keeps the latest item for watches that connect later. Without Google
     * Play services or a watch the task simply fails and is logged.
     */
    private fun publishToWatch(json: String) {
        val request = PutDataMapRequest.create(SNAPSHOT_PATH).apply {
            dataMap.putString(SNAPSHOT_KEY, json)
        }.asPutDataRequest().setUrgent()
        Wearable.getDataClient(this).putDataItem(request)
            .addOnFailureListener { Log.i(TAG, "Watch sync skipped: ${it.message}") }
    }

    private companion object {
        const val TAG = "RytmavoWatch"
        const val WATCH_CHANNEL = "com.rytmavo/watch"

        // Must match android/wear (DataLayerListenerService).
        const val SNAPSHOT_PATH = "/rytmavo/snapshot"
        const val SNAPSHOT_KEY = "json"
    }
}
