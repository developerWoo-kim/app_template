package com.gwkim.app_template

import android.app.PendingIntent
import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import com.google.firebase.FirebaseApp
import com.gwkim.app_template.app.auth.TokenRepository
import com.gwkim.app_template.common.beacon.BeaconScanService
import com.gwkim.app_template.app.driving.AutoDrivingOption
import com.gwkim.app_template.app.driving.AutoDrivingService
import com.gwkim.app_template.app.driving.BatteryWorker
import com.gwkim.app_template.common.timer.TimerHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch
import kotlinx.coroutines.runBlocking

class MainActivity: FlutterActivity() {
    private val AUTH_CHANNEL = "auth_channel"
    private val AUTO_DRIVING_OPTION_CHANNEL = "auto_driving_option_channel"
    private val MANUAL_DRIVING_CHANNEL = "manual_driving_start_channel"
    private val TIMER_EVENT_CHANNEL = "timer_event_channel"


    private lateinit var drivingOption: AutoDrivingOption
    private lateinit var tokenRepository: TokenRepository
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        FirebaseApp.initializeApp(this)


        drivingOption = AutoDrivingOption(applicationContext)
        tokenRepository = TokenRepository(applicationContext)
//        val intentFilter = IntentFilter(Intent.ACTION_BATTERY_CHANGED)
//        val batteryState = registerReceiver(null, intentFilter)
//
//        val status = batteryState!!.getIntExtra(BatteryManager.EXTRA_STATUS, -1)
//        Log.d("battery status", status.toString())
//        Intent(this, TimerService::class.java).also { intent ->
//            bindService(intent, serviceConnection, Context.BIND_AUTO_CREATE)
//        }

//        val beaconScanService = Intent(this, BeaconScanService::class.java)
//        ContextCompat.startForegroundService(this, beaconScanService)
    }

    /**
     * 서비스 바인딩 방식
     */
//    private val serviceConnection = object : ServiceConnection {
//        override fun onServiceConnected(name: ComponentName?, service: IBinder?) {
//            val binder = service as TimerService.LocalBinder
//            timerService = binder.getService()
//            isTimerServiceBound = true
//        }
//
//        override fun onServiceDisconnected(name: ComponentName?) {
//            isTimerServiceBound = false
//        }
//    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        // MethodChannel을 통해 Flutter와 통신 설정
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AUTO_DRIVING_OPTION_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setOption" -> {
                    val autoStartType = call.argument<String>("autoStartType")
                    val beaconAddress = call.argument<String>("beaconAddress")
                    val drivingStartCondition = call.argument<String>("drivingStartCondition")
                    val drivingEndCondition = call.argument<String>("drivingEndCondition")

                    lifecycleScope.launch(Dispatchers.IO) {
                        if (autoStartType != null) {
                            drivingOption.setPreference(AutoDrivingOption.AUTO_START_TYPE, autoStartType)
                        }
                        if (beaconAddress != null) {
                            drivingOption.setPreference(AutoDrivingOption.BEACON_ADDRESS, beaconAddress)
                        }
                        if (drivingStartCondition != null) {
                            drivingOption.setPreference(AutoDrivingOption.DRIVING_START_CONDITION, drivingStartCondition)
                        }
                        if (drivingEndCondition != null) {
                            drivingOption.setPreference(AutoDrivingOption.DRIVING_END_CONDITION, drivingEndCondition)
                        }
                        val address = drivingOption.getPreference(AutoDrivingOption.BEACON_ADDRESS).first() ?: "";
                        Log.d("AutoDrivingOption.BEACON_ADDRESS ::: ", address);

                        if(autoStartType.equals("none")) {
                            context.stopService(Intent(context, AutoDrivingService::class.java))
                        } else {
//                            context.stopService(Intent(context, BeaconScanService::class.java))
//                            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//                                context.startForegroundService(Intent(context, BeaconScanService::class.java))
//                            } else {
//                                context.startService(Intent(context, BeaconScanService::class.java))
//                            }
                            if(AutoDrivingService.isServiceRunning) {
                                context.stopService(Intent(context, AutoDrivingService::class.java))
                            }

                            val intent = Intent(context, AutoDrivingService::class.java)
                            intent.action = AutoDrivingService.ACTION_START
                            ContextCompat.startForegroundService(context, intent)
                        }

                    }

                    result.success(null) // 결과 반환 (이 경우 성공적으로 처리되었음을 알림)
                }
                "getOption" -> {
                    lifecycleScope.launch(Dispatchers.IO) {
                        val autoStartType = drivingOption.getPreference(AutoDrivingOption.AUTO_START_TYPE).first() ?: ""
                        val beaconAddress = drivingOption.getPreference(AutoDrivingOption.BEACON_ADDRESS).first() ?: ""
                        val drivingStartCondition = drivingOption.getPreference(AutoDrivingOption.DRIVING_START_CONDITION).first() ?: ""
                        val drivingEndCondition = drivingOption.getPreference(AutoDrivingOption.DRIVING_END_CONDITION).first() ?: ""

                        val options = mapOf<String, String>(
                                "autoStartType" to autoStartType,
                                "beaconAddress" to beaconAddress,
                                "drivingStartCondition" to drivingStartCondition,
                                "drivingEndCondition" to drivingEndCondition
                        )

                        runOnUiThread {
                            result.success(options)
                        }
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, AUTH_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setAuth" -> {
                    val accessToken = call.argument<String>("accessToken")
                    val refreshToken = call.argument<String>("refreshToken")
                    lifecycleScope.launch(Dispatchers.IO) {
                        if(accessToken != null && refreshToken != null) {
                            tokenRepository.setPreference(TokenRepository.ACCESS_TOKEN_KEY, accessToken)
                            tokenRepository.setPreference(TokenRepository.REFRESH_TOKEN_KEY, refreshToken)
                        } else {
                            result.notImplemented()
                        }
                    }

                    lifecycleScope.launch(Dispatchers.IO) {
                        val findAccessToken = tokenRepository.getPreference(TokenRepository.ACCESS_TOKEN_KEY).first()
                        val findRefreshToken = tokenRepository.getPreference(TokenRepository.REFRESH_TOKEN_KEY).first()
                        findAccessToken?.let { Log.d("findAccessToken", it) }
                        findRefreshToken?.let { Log.d("findRefreshToken", it)}
                    }

                    result.success(null) // 결과 반환

                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, MANUAL_DRIVING_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "start" -> {
                    val accessToken = call.argument<String>("accessToken")
                    val refreshToken = call.argument<String>("refreshToken")
                    lifecycleScope.launch(Dispatchers.IO) {
                        if(accessToken != null && refreshToken != null) {
                            tokenRepository.setPreference(TokenRepository.ACCESS_TOKEN_KEY, accessToken)
                            tokenRepository.setPreference(TokenRepository.REFRESH_TOKEN_KEY, refreshToken)
                        } else {
                            result.notImplemented()
                        }
                    }

                    lifecycleScope.launch(Dispatchers.IO) {
                        val findAccessToken = tokenRepository.getPreference(TokenRepository.ACCESS_TOKEN_KEY).first()
                        val findRefreshToken = tokenRepository.getPreference(TokenRepository.REFRESH_TOKEN_KEY).first()
                        findAccessToken?.let { Log.d("findAccessToken", it) }
                        findRefreshToken?.let { Log.d("findRefreshToken", it)}
                    }

                    result.success(null) // 결과 반환

                }
                "stop" -> {
                    val accessToken = call.argument<String>("accessToken")
                    val refreshToken = call.argument<String>("refreshToken")
                    lifecycleScope.launch(Dispatchers.IO) {
                        if(accessToken != null && refreshToken != null) {
                            tokenRepository.setPreference(TokenRepository.ACCESS_TOKEN_KEY, accessToken)
                            tokenRepository.setPreference(TokenRepository.REFRESH_TOKEN_KEY, refreshToken)
                        } else {
                            result.notImplemented()
                        }
                    }

                    lifecycleScope.launch(Dispatchers.IO) {
                        val findAccessToken = tokenRepository.getPreference(TokenRepository.ACCESS_TOKEN_KEY).first()
                        val findRefreshToken = tokenRepository.getPreference(TokenRepository.REFRESH_TOKEN_KEY).first()
                        findAccessToken?.let { Log.d("findAccessToken", it) }
                        findRefreshToken?.let { Log.d("findRefreshToken", it)}
                    }

                    result.success(null) // 결과 반환

                }
                else -> {
                    result.notImplemented()
                }
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, TIMER_EVENT_CHANNEL).setStreamHandler(
                TimerHandler
        )

//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, TIMER_CHANNEL).setMethodCallHandler {
//            call, result ->
//            if (call.method == "update_time") {
//                lifecycleScope.launch(Dispatchers.IO) {
//                    if(isTimerServiceBound && timerService != null) {
//                        val time = mapOf<String, Long>(
//                                "time" to timerService!!.getElapsedTime()
//                        )
//
//                        runOnUiThread {
//                            result.success(time)
//                        }
//                    }
//                }
//            }
//        }
    }

}
