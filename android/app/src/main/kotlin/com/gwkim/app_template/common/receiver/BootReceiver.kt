package com.gwkim.app_template.common.receiver

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.lifecycle.lifecycleScope
import com.gwkim.app_template.common.beacon.BeaconScanService
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking

class BootReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context?, intent: Intent?) {
        Log.d("BootReceiver", " BootReceiver :: 전원 이벤트")
        if (intent != null) {
            if(intent.action == Intent.ACTION_BOOT_COMPLETED) {
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    context?.startForegroundService(Intent(context, BeaconScanService::class.java))
                } else {
                    context?.startService(Intent(context, BeaconScanService::class.java))
                }
                Log.d("BootReceiver", " BootReceiver :: 부팅 성공")
            }
        }
    }
}