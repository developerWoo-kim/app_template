package com.gwkim.app_template.app.driving

import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.media.SoundPool
import android.os.BatteryManager
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.widget.Toast
import com.gwkim.app_template.MyApplication
import com.gwkim.app_template.R
import com.gwkim.app_template.app.ad.data.DriveLogRequest
import com.gwkim.app_template.app.ad.data.LocationData
import com.gwkim.app_template.common.api.ApiClient
import com.gwkim.app_template.common.location.provider.AndroidLocationProviderClient
import com.gwkim.app_template.common.location.provider.BLLocationProvider
import com.gwkim.app_template.common.location.provider.LocationRequestOptions
import com.gwkim.app_template.common.location.provider.LocationUpdateListener
import com.gwkim.app_template.common.timer.TimerHandler
import com.gwkim.app_template.common.timer.TimerService
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking
import java.util.HashMap

class BatteryStatusMonitoring(private val drivingOption: AutoDrivingOption)  : LocationUpdateListener {
    val soundPool: SoundPool = SoundPool.Builder().build()
    private var context: Context = MyApplication.applicationContext()
    private var locatorClient: BLLocationProvider? = null
    private var isLocationRunning = false;
    private var isDriving = false;

    private var connectMaxFailureCount = 3
    private var connectFailureCount = 0

    private val drivingEndHandler = Handler(Looper.getMainLooper())

    private val monitoringHandler = Handler(Looper.getMainLooper())
    private val monitoringInterval: Long = 5000 // 10 seconds

    fun startMonitoring() {
        Log.d("BatteryStatusMonitoring", " :: startMonitoring")
        monitoringHandler.postDelayed(object : Runnable {
            override fun run() {
                Log.d("BatteryStatusMonitoring", " :: MONITORING.......")
                val batteryStatus: Intent? = IntentFilter(Intent.ACTION_BATTERY_CHANGED).let { ifilter ->
                    context.registerReceiver(null, ifilter)
                }

                val status = batteryStatus?.getIntExtra(BatteryManager.EXTRA_STATUS, -1) ?: -1

                val isCharging = when(status) {
                    BatteryManager.BATTERY_STATUS_CHARGING -> true
                    else -> false
                }

                if(!isCharging) {
                    handleMonitoringFailure()
                } else {
                    connectFailureCount = 0
                    if(!isLocationRunning) {
                        locatorClient = context?.let { getLocationClient(it) }
                        locatorClient?.requestLocationUpdates(LocationRequestOptions())
                        isLocationRunning = true
                        Log.d("SCAN SUCCESS :::: ", "ISDRIVING :: $isDriving")
                    }
                }

                monitoringHandler.postDelayed(this, monitoringInterval)
            }
        }, monitoringInterval)
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
            ApiClient.apiService.sendDriveLog("true", DriveLogRequest("AD_0000021",data))
        }

    }

    fun startDriving() {
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

        context.startService(Intent(context, TimerService::class.java))
    }

    fun handleMonitoringFailure() {
        Log.d("BatteryMonitoring", "Connect result: false")
        if(isLocationRunning) {
            connectFailureCount++
            if(connectFailureCount >= connectMaxFailureCount) {
                locatorClient?.removeLocationUpdates()
                isLocationRunning = false

                if(isDriving) {
                    stopDriving()
                }
            }
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