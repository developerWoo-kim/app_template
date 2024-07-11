package com.gwkim.app_template.common.beacon

import android.app.*
import android.content.Context
import android.content.Intent
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import android.util.Log
import androidx.core.app.NotificationCompat
import com.gwkim.app_template.MainActivity

import org.koin.android.ext.android.inject
import java.util.HashMap

class BeaconScanService : Service() {
    private val beaconScanner: BeaconScanner by inject()
    companion object {
        private val channelId = "BeaconScanServiceChannel"
        private var isRunning = false
    }

//    override fun onCreate() {
//        super.onCreate()
//        Log.d("BeaconScanService", "START :::: BeaconScanService")
//        val beaconScanner = BeaconScanner("C3:00:00:1C:65:91")
//        beaconScanner.startPeriodicScan()
//        startForegroundService()
//    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startForegroundService()
        beaconScanner.startPeriodicScan()
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        beaconScanner.stopPeriodicScan()
        Log.d("BeaconScanService :: onDestroy()", "Service destroyed and scanning stopped")
    }

    private fun startForegroundService() {
        createNotificationChannel()
        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(
                this,
                0, notificationIntent, PendingIntent.FLAG_UPDATE_CURRENT
        )

        val notification: Notification = NotificationCompat.Builder(this, channelId)
                .setContentTitle("애드럭과 beacon scanning...")
                .setContentText("Scanning for BLE devices...")
//                .setSmallIcon(R.drawable.ic_notification) // Add your own notification icon here
                .setContentIntent(pendingIntent)
//                .setOngoing(true)
                .build()

        startForeground(1, notification)
    }

    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                    channelId,
                    "Bluetooth Service Channel",
                    NotificationManager.IMPORTANCE_DEFAULT
            )
            val manager = getSystemService(NotificationManager::class.java)
            manager.createNotificationChannel(serviceChannel)
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

}