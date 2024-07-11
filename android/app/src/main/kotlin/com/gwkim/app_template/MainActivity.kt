package com.gwkim.app_template

import android.content.Intent
import android.os.Build
import android.os.Bundle
import android.util.Log
import androidx.core.content.ContextCompat
import androidx.lifecycle.lifecycleScope
import com.gwkim.app_template.common.beacon.BeaconScanService
import com.gwkim.app_template.driving.AutoDrivingOption
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.launch

class MainActivity: FlutterActivity() {
    private val AUTO_DRIVING_OPTION_CHANNEL = "auto_driving_option_channel"
    private lateinit var drivingOption: AutoDrivingOption
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        drivingOption = AutoDrivingOption(applicationContext)
//        val beaconScanService = Intent(this, BeaconScanService::class.java)
//        ContextCompat.startForegroundService(this, beaconScanService)
    }

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
                            drivingOption.saveAutoStartType(autoStartType)
                        }
                        if (beaconAddress != null) {
                            drivingOption.saveBeaconAddress(beaconAddress)
                        }
                        if (drivingStartCondition != null) {
                            drivingOption.saveDrivingStartCondition(drivingStartCondition)
                        }
                        if (drivingEndCondition != null) {
                            drivingOption.saveDrivingEndCondition(drivingEndCondition)
                        }

                        if(autoStartType.equals("none")) {
                            context.stopService(Intent(context, BeaconScanService::class.java))
                        } else if(autoStartType.equals("beacon")) {
                            context.startService(Intent(context, BeaconScanService::class.java))
                        }

                    }

//                    if (accessToken != null && refreshToken != null) {
//                        lifecycleScope.launch(Dispatchers.IO) {
//
//                        }
//                    }
                    CoroutineScope(Dispatchers.IO).launch {
                        Log.d("drivingOption autoStartType", "${System.identityHashCode(drivingOption.getAutoStartType().first())}")
                        Log.d("drivingOption beaconAddress", "${System.identityHashCode(drivingOption.getBeaconAddress().first())}")
                        Log.d("drivingOption drivingStartCondition", "${System.identityHashCode(drivingOption.getDrivingStartCondition().first())}")
                        Log.d("drivingOption drivingEndCondition", "${System.identityHashCode(drivingOption.getDrivingEndCondition().first())}")
                    }

                    result.success(null) // 결과 반환 (이 경우 성공적으로 처리되었음을 알림)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
