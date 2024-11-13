package com.gwkim.app_template.common.beacon

import android.app.AlarmManager
import android.app.PendingIntent
import android.app.Service
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.content.Intent
import android.media.SoundPool
import android.os.Handler
import android.os.Looper
import android.os.PowerManager
import android.os.SystemClock
import android.util.Log
import android.widget.Toast
import androidx.core.content.ContextCompat.getSystemService
import androidx.lifecycle.lifecycleScope
import com.google.firebase.ktx.Firebase
import com.google.firebase.messaging.ktx.messaging
import com.gwkim.app_template.MyApplication
import com.gwkim.app_template.R
import com.gwkim.app_template.app.ad.data.DriveLogRequest
import com.gwkim.app_template.app.ad.data.LocationData
import com.gwkim.app_template.common.location.provider.*
import com.gwkim.app_template.app.driving.AutoDrivingOption
import com.gwkim.app_template.common.alarm.AlarmReceiver
import com.gwkim.app_template.common.api.ApiClient
import com.gwkim.app_template.common.timer.TimerHandler
import com.gwkim.app_template.common.timer.TimerService
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking
import java.util.HashMap


class BeaconScanner(private val drivingOption: AutoDrivingOption) : LocationUpdateListener {
    var runningAdSn: String = ""
    val soundPool:SoundPool = SoundPool.Builder().build()
    private var context: Context = MyApplication.applicationContext()
    private var locatorClient: BLLocationProvider? = null
    private var isLocationRunning = false;
    private var isDriving = false;
    // ble manager
    val bleManager: BluetoothManager =
            MyApplication.applicationContext().getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
    // ble adapter
    val bleAdapter: BluetoothAdapter? get() = bleManager.adapter
    // location manager

    private val scanHandler = Handler(Looper.getMainLooper())
    private val scanInterval: Long = 5000 // 3 seconds
    private var scanMaxFailureCount = 3
    private var scanFailureCount = 0

    var isScan = false
    var scanResults: ArrayList<BluetoothDevice>? = ArrayList()

    private val drivingEndHandler = Handler(Looper.getMainLooper())

    private val scanCallback = object : ScanCallback() {
        override fun onScanResult(callbackType: Int, result: ScanResult) {
            super.onScanResult(callbackType, result)
            Log.d("BleScanner", "Scan result: ${result.device.address}")
            isScan = true
            scanFailureCount = 0
            addScanResult(result)
            stopScan()
        }

        override fun onScanFailed(errorCode: Int) {
            super.onScanFailed(errorCode)
            Log.d("BleScanner", "Scan failed with error: $errorCode")
            // Increment failure count on scan failure
            scanFailureCount++
            if (scanFailureCount >= scanMaxFailureCount) {
                Log.d("BleScanner", "Max scan failures reached, setting scan result to false")
                handleScanFailure()
            }
        }

        private fun addScanResult(result: ScanResult) {
            // get scanned device
            val device = result.device
            // get scanned device MAC address
            val deviceAddress = device.address
            val deviceName = device.name
            // add the device to the result list
            for (dev in scanResults!!) {
                if (dev.address == deviceAddress) return
            }
            scanResults?.add(result.device)
        }
    }

    private fun startScan(filters: MutableList<ScanFilter>, settings: ScanSettings) {
        bleAdapter?.bluetoothLeScanner?.startScan(filters, settings, scanCallback)
    }

    private fun stopScan() {
        bleAdapter?.bluetoothLeScanner?.stopScan(scanCallback)
    }

    fun startPeriodicScan() {
        runBlocking {
            val userModel = ApiClient.apiService.getUser("true")
            runningAdSn = userModel.runningAdSn
        }

        val filters: MutableList<ScanFilter> = ArrayList()
        runBlocking {
            val beaconAddress = drivingOption.getPreference(AutoDrivingOption.BEACON_ADDRESS).first() ?: ""
            Log.d("startPeriodicScan ::: ", beaconAddress);
            val scanFilter: ScanFilter = ScanFilter.Builder()
                    .setDeviceAddress(beaconAddress)
                    .build()
            filters.add(scanFilter)
        }
        val settings = ScanSettings.Builder()
                .setScanMode(ScanSettings.SCAN_MODE_LOW_POWER)
                .build()

        scanHandler.postDelayed(object : Runnable {
            override fun run() {
                Log.d("BleScanner", "SCANNING MAX FAILURE COUNT :: $scanMaxFailureCount")
                Log.d("BleScanner", "SCANNING FAILURE COUNT :: $scanFailureCount")
                Log.d("BleScanner", "Starting BLE scan")
                isScan = false
                startScan(filters, settings)

                scanHandler.postDelayed({
                    Log.d("BleScanner", "Stopping BLE scan")
                    stopScan()
                    if(!isScan) {
                        handleScanFailure()
                    } else {
                        if(!isLocationRunning) {
                            locatorClient = context?.let { getLocationClient(it) }
                            locatorClient?.requestLocationUpdates(LocationRequestOptions())
                            isLocationRunning = true
                            Log.d("SCAN SUCCESS :::: ", "ISDRIVING :: $isDriving")
                        }
                    }

                    // Schedule next scan
                    scanHandler.postDelayed(this, scanInterval)
                }, scanInterval)
            }
        }, scanInterval)
    }

    fun stopPeriodicScan() {
        scanHandler.removeCallbacksAndMessages(null)
        stopScan()
        scanFailureCount = 0;
        isScan = false;
        isLocationRunning = false;
        isDriving = false;
    }

    private fun handleScanFailure() {
        Log.d("BleScanner", "Scan result: false")
        if(isLocationRunning) {
            scanFailureCount++
            if(scanFailureCount >= scanMaxFailureCount) {
                locatorClient?.removeLocationUpdates()
                isLocationRunning = false

                if(isDriving) {
                    stopDriving()
                }
            }
        }

        Log.d("handleScanFailure", "handleScanFailure isDriving $isDriving")
    }

    private fun getLocationClient(context: Context): BLLocationProvider {
        return AndroidLocationProviderClient(context, this)
    }
    override fun onLocationUpdated(location: HashMap<Any, Any>?) {
        if (location != null) {
            val result: HashMap<Any, Any> =
                    hashMapOf(
                            "location" to location
                    )

            if(!isDriving) {
                val drivingStartConditionStr = runBlocking {
                    drivingOption.getPreference(AutoDrivingOption.DRIVING_START_CONDITION).first() ?: ""
                }
                Log.d("drivingStartConditionStr", "start condition ::: $drivingStartConditionStr")

                val drivingStartCondition = drivingStartConditionStr.toFloatOrNull()
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
                            Log.d("onLocationUpdated", "Condition not met: speed = $speedKmh, drivingStartCondition = $drivingStartConditionStr")
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

    fun sendLocationToServer(location: HashMap<Any, Any>, sttscd: String) {
        val latitude = location["latitude"] as Double
        val longitude = location["longitude"] as Double
        val sttscd = sttscd
        val time = location["time"] as Double

        val data : List<LocationData> = listOf(LocationData(latitude, longitude, sttscd, time))
        runBlocking {
            try {
                ApiClient.apiService.sendDriveLog("true", DriveLogRequest(runningAdSn,data))
            } catch (e: Exception) {
                Log.e("API ERROR", e.message.toString())
            }

        }

    }

    fun startDriving() {
        Firebase.messaging.subscribeToTopic("driving")
                .addOnCompleteListener{ task ->
                    var msg = "Subscribed"
                    if(!task.isSuccessful) {
                        msg = "Subscribed failed"
                    }
                    Log.d("Firebase.messaging.subscribeToTopic :: ", msg)
                }.addOnFailureListener{ task ->
                    var msg = "Subscribed failed"
                    Log.d("Firebase.messaging.subscribeToTopic :: ", msg)
                }

        TimerHandler.startTimer()
        isDriving = true;
        var soundId : Int = 0
        soundId = soundPool.load(context, R.raw.drive_start_action_audio, 1)
        soundPool.setOnLoadCompleteListener { soundPool, sountId, status ->
            if (status == 0) { // Status 0 means the sound was loaded successfully
                soundPool.play(soundId, 1f, 1f, 0, 0, 1f)
            }
        }
        Toast.makeText(context, "애드럭과 함께 운행이 시작되었습니다!", Toast.LENGTH_SHORT).show();
    }
    fun acquireWakeLock() {
        val powerManager = context.getSystemService(Context.POWER_SERVICE) as PowerManager
        val wakeLock = powerManager.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, "MyApp::MyWakelockTag")
        wakeLock.acquire(1000 * 10)
    }
    fun releaseWakeLock(wakeLock: PowerManager.WakeLock) {
        if (wakeLock.isHeld) {
            wakeLock.release()
        }
    }

    fun stopDriving() {
        runBlocking {
            val drivingEndConditionStr = drivingOption.getPreference(AutoDrivingOption.DRIVING_END_CONDITION).first() ?: ""

            val drivingEndCondition = drivingEndConditionStr.toLongOrNull()
            Log.d("drivingEndCondition", "drivingEndCondition $drivingEndCondition")
            Log.d("drivingEndCondition", "drivingEndCondition isDriving $isDriving")
            if(drivingEndCondition != null) {
                drivingEndHandler.postDelayed({
                    if(!isLocationRunning) {
                        Firebase.messaging.unsubscribeFromTopic("driving")
                        TimerHandler.stopTimer()
                        isDriving = false

                        runBlocking {
                            ApiClient.apiService.forceQuitDriveLog("true");
                        }

                        var soundId : Int = 0
                        soundId = soundPool.load(context, R.raw.drive_end_action_audio, 1)
                        soundPool.setOnLoadCompleteListener { soundPool, sountId, status ->
                            if (status == 0) { // Status 0 means the sound was loaded successfully
                                soundPool.play(soundId, 1f, 1f, 0, 0, 1f)
                            }
                        }

                        Toast.makeText(context, "운행이 종료되었습니다.", Toast.LENGTH_SHORT).show();
                    }
                }, drivingEndCondition * 1000)
            } else {
                Firebase.messaging.unsubscribeFromTopic("driving")
                TimerHandler.stopTimer()
                isDriving = false

                runBlocking {
                    ApiClient.apiService.forceQuitDriveLog("true");
                }

                var soundId : Int = 0
                soundId = soundPool.load(context, R.raw.drive_end_action_audio, 1)
                soundPool.setOnLoadCompleteListener { soundPool, sountId, status ->
                    if (status == 0) { // Status 0 means the sound was loaded successfully
                        soundPool.play(soundId, 1f, 1f, 0, 0, 1f)
                    }
                }

                Toast.makeText(context, "운행이 종료되었습니다.", Toast.LENGTH_SHORT).show();
            }

        }
    }
}