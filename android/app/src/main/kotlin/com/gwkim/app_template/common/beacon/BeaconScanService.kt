package com.gwkim.app_template.common.beacon

import android.app.*
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.location.Location
import android.location.LocationListener
import android.location.LocationManager
import android.os.Build
import android.os.Bundle
import android.os.IBinder
import android.os.SystemClock
import android.util.Log
import android.widget.Toast
import androidx.core.app.NotificationCompat
import com.gwkim.app_template.MainActivity
import com.gwkim.app_template.MyApplication
import com.gwkim.app_template.R
import com.gwkim.app_template.app.auth.TokenRepository
import com.gwkim.app_template.app.driving.AutoDrivingOption
import com.gwkim.app_template.app.driving.BatteryStatusMonitoring
import com.gwkim.app_template.common.alarm.AlarmReceiver
import com.gwkim.app_template.common.receiver.BootReceiver
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking

import org.koin.android.ext.android.inject
import java.util.HashMap

class BeaconScanService : Service() {
    lateinit var notificationManager: NotificationManager

    private lateinit var drivingOption: AutoDrivingOption
    private lateinit var tokenRepository: TokenRepository
    private val beaconScanner: BeaconScanner by inject()
    private val batteryStatusMonitoring: BatteryStatusMonitoring by inject()
    private val bootReceiver: BootReceiver = BootReceiver()
    companion object {
        private val channelId = "BeaconScanServiceChannel"
    }

    override fun onCreate() {
        super.onCreate()
        Log.d("BeaconScanService", "START :::: BeaconScanService")

        drivingOption = AutoDrivingOption(applicationContext)
        tokenRepository = TokenRepository(applicationContext)
        runBlocking {
            val address = drivingOption.getPreference(AutoDrivingOption.BEACON_ADDRESS).first() ?: ""
            Log.d("BeaconScanService onCreate", address)

            val accessToken = tokenRepository.getPreference(TokenRepository.ACCESS_TOKEN_KEY).first() ?: ""
            Log.d("BeaconScanService onCreate", accessToken)
        }

        registerReceiver(bootReceiver, IntentFilter().apply() {
            addAction("android.intent.action.BOOT_COMPLETED")
        })

    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        startForegroundService()
        runBlocking {
            val autoStartType = drivingOption.getPreference(AutoDrivingOption.AUTO_START_TYPE).first() ?: ""

            when(autoStartType) {
                "battery" -> batteryStatusMonitoring.startMonitoring()
                "beacon" -> beaconScanner.startPeriodicScan()
            }
        }

//        batteryStatusMonitoring.startMonitoring()
//        beaconScanner.startPeriodicScan()
        return START_STICKY
    }

    override fun onDestroy() {
        super.onDestroy()
        beaconScanner.stopPeriodicScan()
        batteryStatusMonitoring.stopMonitoring()
        unregisterReceiver(bootReceiver)
        Log.d("BeaconScanService :: onDestroy()", "Service destroyed and scanning stopped")
    }

    private fun startForegroundService() {
        createNotificationChannel()

        val notificationIntent = Intent(this, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(this, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE)

        val notification: Notification = NotificationCompat.Builder(this, channelId)
                .setContentTitle("애드럭과 beacon scanning...")
                .setContentText("Scanning for BLE devices...")
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setOngoing(true)
                .setSmallIcon(R.drawable.navermap_default_cluster_icon_medium_density) // Add your own notification icon here
                .setContentIntent(pendingIntent)
                .build()

        if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.TIRAMISU) {
            notification.flags = Notification.FLAG_ONGOING_EVENT
        } else {
            notification.flags = Notification.FLAG_NO_CLEAR
        }

        startForeground(1, notification)
    }

    private fun createNotificationChannel() {
        notificationManager = getSystemService(NotificationManager::class.java)

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val serviceChannel = NotificationChannel(
                    channelId,
                    "Bluetooth Service Channel",
                    NotificationManager.IMPORTANCE_HIGH
            )

            notificationManager.createNotificationChannel(serviceChannel)
        }
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

}