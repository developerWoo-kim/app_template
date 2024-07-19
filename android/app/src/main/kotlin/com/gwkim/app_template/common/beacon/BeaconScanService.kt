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
import android.util.Log
import android.widget.Toast
import androidx.core.app.NotificationCompat
import com.gwkim.app_template.MainActivity
import com.gwkim.app_template.MyApplication
import com.gwkim.app_template.app.auth.TokenRepository
import com.gwkim.app_template.app.driving.AutoDrivingOption
import com.gwkim.app_template.app.driving.BatteryStatusMonitoring
import com.gwkim.app_template.common.receiver.BootReceiver
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking

import org.koin.android.ext.android.inject
import java.util.HashMap

class BeaconScanService : Service() {
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