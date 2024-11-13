package com.gwkim.app_template.app.driving

import android.app.*
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothManager
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.ServiceInfo
import android.media.SoundPool
import android.os.*
import android.util.Log
import android.widget.Toast
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import androidx.core.app.ServiceCompat
import androidx.core.content.ContextCompat
import com.google.firebase.ktx.Firebase
import com.google.firebase.messaging.ktx.messaging
import com.gwkim.app_template.MainActivity
import com.gwkim.app_template.MyApplication
import com.gwkim.app_template.R
import com.gwkim.app_template.app.ad.data.DriveLogRequest
import com.gwkim.app_template.app.ad.data.LocationData
import com.gwkim.app_template.app.auth.TokenRepository
import com.gwkim.app_template.app.driving.AutoDrivingService.AutoDrivingService.autoStartType
import com.gwkim.app_template.app.driving.AutoDrivingService.AutoDrivingService.beaconAddress
import com.gwkim.app_template.app.driving.AutoDrivingService.AutoDrivingService.bluetoothAdapter
import com.gwkim.app_template.app.driving.AutoDrivingService.AutoDrivingService.drivingEndCondition
import com.gwkim.app_template.app.driving.AutoDrivingService.AutoDrivingService.drivingStartCondition
import com.gwkim.app_template.app.driving.AutoDrivingService.AutoDrivingService.failureCount
import com.gwkim.app_template.app.driving.AutoDrivingService.AutoDrivingService.failureMaxCount
import com.gwkim.app_template.app.driving.AutoDrivingService.AutoDrivingService.isDriving
import com.gwkim.app_template.app.driving.AutoDrivingService.AutoDrivingService.isLocationRunning
import com.gwkim.app_template.app.driving.AutoDrivingService.AutoDrivingService.isScan
import com.gwkim.app_template.app.driving.AutoDrivingService.AutoDrivingService.locatorClient
import com.gwkim.app_template.app.driving.AutoDrivingService.AutoDrivingService.runningAdSn
import com.gwkim.app_template.common.alarm.AlarmReceiver
import com.gwkim.app_template.common.api.ApiClient
import com.gwkim.app_template.common.location.provider.AndroidLocationProviderClient
import com.gwkim.app_template.common.location.provider.BLLocationProvider
import com.gwkim.app_template.common.location.provider.LocationRequestOptions
import com.gwkim.app_template.common.location.provider.LocationUpdateListener
import com.gwkim.app_template.common.receiver.BootReceiver
import com.gwkim.app_template.common.timer.TimerHandler
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking
import java.util.HashMap

class AutoDrivingService: LocationUpdateListener, Service() {
    private val autoDrivingOption = AutoDrivingOption(MyApplication.instance)
    companion object {
        @JvmStatic
        var isServiceRunning = false

        @JvmStatic
        val ACTION_START = "START"

        @JvmStatic
        val ACTION_SHUTDOWN = "SHUTDOWN"

        @JvmStatic
        val ACTION_STOP_DRIVING = "STOP_DRIVING"

        @JvmStatic
        val TAG = "AutoDrivingService"

        @JvmStatic
        private val WAKELOCK_TAG = "AutoDrivingService::WAKE_LOCK"

        @JvmStatic
        val notificationId = 101

        @JvmStatic
        val monitoringInterval: Long = 5000 // 5초

        @JvmStatic
        val monitoringHandler = Handler(Looper.getMainLooper())

        @JvmStatic
        val drivingEndHandler = Handler(Looper.getMainLooper())

        @JvmStatic
        val soundPool: SoundPool = SoundPool.Builder().build()
    }
    object AutoDrivingService {
        var isLocationRunning = false
        var isDriving = false
        var isScan = false

        var failureMaxCount = 3
        var failureCount = 0

        var runningAdSn: String = ""
        var autoStartType: String = ""
        var beaconAddress: String = ""
        var drivingStartCondition: String = ""
        var drivingEndCondition: String = ""

        val bluetoothManager: BluetoothManager =
                MyApplication.applicationContext().getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
        val bluetoothAdapter: BluetoothAdapter? get() = bluetoothManager.adapter

        var locatorClient: BLLocationProvider? = null
    }

    private var notificationChannelName = "Auto Driving Channel"
    private val bootReceiver: BootReceiver = BootReceiver()
    private var wakeLockTime = 10 * 60 * 1000L
    
    override fun onCreate() {
        super.onCreate()
        Log.d(TAG, ":::: START ::::")

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            startForeground(notificationId, getNotification(), ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION)
        } else {
            startForeground(notificationId, getNotification())
        }

        registerReceiver(bootReceiver, IntentFilter().apply() {
            addAction("android.intent.action.BOOT_COMPLETED")
        })
    }

    private fun getNotification(): Notification {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            // Notification channel is available in Android O and up
            val channel = NotificationChannel(
                    AutoDrivingKeys.AUTO_DRIVING_BACKGROUND_CHANNEL_ID, notificationChannelName,
                    NotificationManager.IMPORTANCE_LOW
            )

            (getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager)
                    .createNotificationChannel(channel)
        }

        val intent = Intent(this, MainActivity::class.java)
        val pendingIntent: PendingIntent = PendingIntent.getActivity(this,
                1, intent, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)

        var icon = resources.getIdentifier("ic_launcher", "mipmap", packageName)
        return NotificationCompat.Builder(this, AutoDrivingKeys.AUTO_DRIVING_BACKGROUND_CHANNEL_ID)
                .setContentTitle("애드럭 자동운행기록 사용중")
                .setContentText("ㅅㄷㄴㅅㄷㅅㄷㄴㅅㄴㄷ")
//                .setStyle(
//                        NotificationCompat.BigTextStyle()
//                                .bigText(notificationBigMsg)
//                )
                .setSmallIcon(icon)
//                .setColor(notificationIconColor)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setContentIntent(pendingIntent)
                .setOnlyAlertOnce(true) // so when data is updated don't make sound and alert in android 8.0+
                .setOngoing(true)
                .build()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        Log.d(TAG, ":::: START onStartCommand ::::")
        runBlocking {
            autoStartType = autoDrivingOption.getPreference(AutoDrivingOption.AUTO_START_TYPE).first() ?: ""
            beaconAddress = autoDrivingOption.getPreference(AutoDrivingOption.BEACON_ADDRESS).first() ?: ""
            drivingStartCondition = autoDrivingOption.getPreference(AutoDrivingOption.DRIVING_START_CONDITION).first() ?: ""
            drivingEndCondition = autoDrivingOption.getPreference(AutoDrivingOption.DRIVING_END_CONDITION).first() ?: ""

            val userModel = ApiClient.apiService.getUser("true")
            runningAdSn = userModel.runningAdSn
        }

        when (intent?.action) {
            ACTION_START -> {
                Log.d(TAG, ":::::: ACTION_START")
                isServiceRunning = true
                startMonitoring()
            }
            ACTION_SHUTDOWN -> {
                Log.d(TAG, ":::::: ACTION_SHUTDOWN")
                isServiceRunning = false
                shutdownAutoDrivingService()
            }
            ACTION_STOP_DRIVING -> {
                Log.d(TAG, ":::::: ACTION_START_DRIVING")
                stopDriving()
            }
        }
        return START_REDELIVER_INTENT
    }

    override fun onDestroy() {
        super.onDestroy()
        stopMonitoring()
        unregisterReceiver(bootReceiver)
        Log.d(TAG, ":::::: onDestroy :::::: ")
    }

    private fun shutdownAutoDrivingService() {
        stopMonitoring()
        stopSelf()
    }


    private fun startMonitoring() {
        locatorClient = applicationContext?.let { getLocationClient(it) }
        locatorClient?.requestLocationUpdates(LocationRequestOptions())

        when(autoStartType) {
            "beacon" -> scanningBeacon()
            "battery" -> scanningBatteryState()
        }
    }

    private fun stopMonitoring() {
        monitoringHandler.removeCallbacksAndMessages(null)
    }

    private fun scanningBeacon() {
        val filters: MutableList<ScanFilter> = ArrayList()
        Log.d(TAG, "::::: scanningBeacon ::::: $beaconAddress")
        val scanFilter: ScanFilter = ScanFilter.Builder()
                .setDeviceAddress(beaconAddress)
                .build()
        filters.add(scanFilter)
        val settings = ScanSettings.Builder()
                .setScanMode(ScanSettings.SCAN_MODE_LOW_POWER)
                .build()

        while (isServiceRunning) {
            startScan(filters, settings)
            SystemClock.sleep(5000)

        }

        monitoringHandler.postDelayed(object : Runnable {
            override fun run() {
                Log.d(TAG, "::::: SCANNING MAX FAILURE COUNT ::::: $failureMaxCount")
                Log.d(TAG, "::::: SCANNING FAILURE COUNT ::::: $failureCount")
                isScan = false
                startScan(filters, settings)

                monitoringHandler.postDelayed({
                    Log.d(TAG, "Stopping BLE scan")
                    stopScan()
                    if(!isScan) {
                        handleFailure()
                    } else {
                        if(!isLocationRunning) {
                            isLocationRunning = true
                            Log.d(TAG, "ISDRIVING :: $isDriving")
                        }
                    }

                    // Schedule next scan
                    monitoringHandler.postDelayed(this, monitoringInterval)
                }, monitoringInterval)
            }
        }, monitoringInterval)
    }

    private fun getLocationClient(context: Context): BLLocationProvider {
        return AndroidLocationProviderClient(context, this)
    }

    private fun startScan(filters: MutableList<ScanFilter>, settings: ScanSettings?) {
        bluetoothAdapter?.bluetoothLeScanner?.startScan(filters, settings, scanCallback)
    }

    private fun stopScan() {
        bluetoothAdapter?.bluetoothLeScanner?.stopScan(scanCallback)
    }

    private val scanCallback = object : ScanCallback() {
        override fun onScanResult(callbackType: Int, result: ScanResult) {
            super.onScanResult(callbackType, result)
            Log.d(TAG, "BleScanner Scan result: ${result.device.address}")
            isScan = true
            failureCount = 0
            stopScan()
        }

        override fun onScanFailed(errorCode: Int) {
            super.onScanFailed(errorCode)
            Log.d("BleScanner", "Scan failed with error: $errorCode")
            failureCount++
            if (failureCount >= failureMaxCount) {
                handleFailure()
            }
        }
    }

    private fun scanningBatteryState() {
        monitoringHandler.postDelayed(object : Runnable {
            override fun run() {
                Log.d(TAG, " ::::: BATTERY MONITORING ::::: ")
                val batteryStatus: Intent? = IntentFilter(Intent.ACTION_BATTERY_CHANGED).let { ifilter ->
                    applicationContext.registerReceiver(null, ifilter)
                }

                var isCharging = false
                val status = batteryStatus?.getIntExtra(BatteryManager.EXTRA_PLUGGED, -1) ?: -1
                if(status == BatteryManager.BATTERY_PLUGGED_AC || status == BatteryManager.BATTERY_PLUGGED_USB || status == BatteryManager.BATTERY_PLUGGED_DOCK || status == BatteryManager.BATTERY_PLUGGED_WIRELESS) {
                    isCharging = true
                }

                if(!isCharging) {
                    handleFailure()
                } else {
                    failureCount = 0
                    if(!isLocationRunning) {
                        isLocationRunning = true
                        Log.d(TAG, "ISDRIVING :: $isDriving")
                    }
                }

                monitoringHandler.postDelayed(this, monitoringInterval)
            }
        }, monitoringInterval)
    }

    private fun handleFailure() {
        Log.d(TAG, "::::: handleFailure :::::")
        Log.d(TAG, "::::: isLocationRunning ::::: $isLocationRunning")
        Log.d(TAG, "::::: isDriving ::::: $isDriving")
        Log.d(TAG, "::::: failureCount ::::: $failureCount")
        if(isLocationRunning) {
            failureCount++
            if(failureCount >= failureMaxCount) {
                isLocationRunning = false

                if(isDriving) {
                    Log.d(TAG, "::::: stopDriving :::::")
//                    stopDriving()
                    val drivingEndCondition = drivingEndCondition.toLongOrNull()
                    if(drivingEndCondition != null) {
                        val alarmManager = applicationContext.getSystemService(Context.ALARM_SERVICE) as AlarmManager
                        val intent = Intent(applicationContext, AlarmReceiver::class.java)
                        val pendingIntent = PendingIntent.getBroadcast(applicationContext, 0, intent, PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)

                        val triggerTime = System.currentTimeMillis() + (1000 * drivingEndCondition)
//                        alarmManager.setExactAndAllowWhileIdle(AlarmManager.ELAPSED_REALTIME_WAKEUP, triggerTime, pendingIntent)
                        alarmManager.setAlarmClock(AlarmManager.AlarmClockInfo(triggerTime, pendingIntent), pendingIntent)
                    }
                }
            }
        }

        Log.d("handleScanFailure", "handleScanFailure isDriving $isDriving")
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    override fun onLocationUpdated(location: HashMap<Any, Any>?) {
        if(isLocationRunning) {
            if (location != null) {
                val result: HashMap<Any, Any> =
                        hashMapOf(
                                "location" to location
                        )
                if(!isDriving) {
                    val drivingStartCondition = drivingStartCondition.toFloatOrNull()

                    if (drivingStartCondition != null) {
                        Log.d("onLocationUpdated", "drivingStartConditionStr != null ::::: $drivingStartCondition")
                        val speedMps = location["speed"] as? Float

                        if(speedMps != null) {
                            val speedKmh = speedMps * 3.6

                            if(speedKmh > drivingStartCondition) {
                                // Speed is greater than drivingStartCondition, add your condition handling code here
                                Log.d("onLocationUpdated", "Speed is greater than drivingStartCondition: $speedKmh > $drivingStartCondition")
                                startDriving()
                                sendLocationToServer(location, "MNG006001")
                            } else {
                                Log.d("onLocationUpdated", "Condition not met: speed = $speedKmh, drivingStartCondition = $drivingStartCondition")
                            }
                        }

                    } else {
                        startDriving()
                        sendLocationToServer(location, "MNG006001")
                    }
                } else {
                    sendLocationToServer(location, "MNG006002")
                }

                Log.d("onLocationUpdated", "onLocationUpdated ::::: $result")
            }
        }
    }

    private fun sendLocationToServer(location: HashMap<Any, Any>, sttscd: String) {
        val latitude = location["latitude"] as Double
        val longitude = location["longitude"] as Double
        val sttscd = sttscd
        val time = location["time"] as Double

        val data : List<LocationData> = listOf(LocationData(latitude, longitude, sttscd, time))
        runBlocking {
            try {
                ApiClient.apiService.sendDriveLog("true", DriveLogRequest(runningAdSn,data))
            } catch (e:Exception) {
                e.message?.let { Log.d(TAG, "API CLIENT EXCEPTION ::::: $it") }
            }

        }

    }

    private fun startDriving() {
        TimerHandler.startTimer()
        isDriving = true;
        var soundId : Int = 0
        soundId = soundPool.load(applicationContext, R.raw.drive_start_action_audio, 1)
        soundPool.setOnLoadCompleteListener { soundPool, sountId, status ->
            if (status == 0) { // Status 0 means the sound was loaded successfully
                soundPool.play(soundId, 1f, 1f, 0, 0, 1f)
            }
        }
        Toast.makeText(applicationContext, "애드럭과 함께 운행이 시작되었습니다!", Toast.LENGTH_SHORT).show();
    }

    private fun stopDriving() {
        TimerHandler.stopTimer()
        isDriving = false

        var soundId: Int = 0
        soundId = soundPool.load(applicationContext, R.raw.drive_end_action_audio, 1)
        soundPool.setOnLoadCompleteListener { soundPool, sountId, status ->
            if (status == 0) { // Status 0 means the sound was loaded successfully
                soundPool.play(soundId, 1f, 1f, 0, 0, 1f)
            }
        }

        Toast.makeText(applicationContext, "운행이 종료되었습니다.", Toast.LENGTH_SHORT).show();

        runBlocking {
            ApiClient.apiService.forceQuitDriveLog("true");
        }
    }
}