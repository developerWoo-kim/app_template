package com.gwkim.app_template

import android.app.Application
import android.content.Context
import android.util.Log
import android.widget.Toast
import com.google.android.gms.tasks.OnCompleteListener
import com.google.firebase.FirebaseApp
import com.gwkim.app_template.app.auth.TokenRepository
import com.gwkim.app_template.common.di.batteryStatusMonitoringModule
import com.gwkim.app_template.common.di.beaconScannerModule
import com.gwkim.app_template.common.di.repositoryModule
import org.koin.android.ext.koin.androidContext
import org.koin.android.ext.koin.androidFileProperties
import org.koin.android.ext.koin.androidLogger
import org.koin.core.context.startKoin

class MyApplication : Application() {

    init{
        instance = this
    }

    companion object {
        lateinit var instance: MyApplication
        lateinit var tokenRepository: TokenRepository
        fun applicationContext() : Context {
            return instance.applicationContext
        }
    }

    override fun onCreate() {
        super.onCreate()
        FirebaseApp.initializeApp(this)
        tokenRepository = TokenRepository(this)

        startKoin {
            // 로그를 찍어볼 수 있다.
            // 에러확인 - androidLogger(Level.ERROR)
            androidLogger()
            // Android Content를 넘겨준다.
            androidContext(this@MyApplication)
            // assets/koin.properties 파일에서 프로퍼티를 가져옴
            androidFileProperties()
            //module list
            modules(listOf(repositoryModule, beaconScannerModule, batteryStatusMonitoringModule))
        }

        // 현재 토큰을 가져오려면
        // FirebaseMessaging.getInstace().getToken()을 호출한다.
//        FirebaseMessaging.getInstance().token.addOnCompleteListener(OnCompleteListener { task ->
//            if (!task.isSuccessful) {
//                Log.w("MainActivity", "Fetching FCM registration token failed", task.exception)
//                return@OnCompleteListener
//            }
//
//            // FCM 등록 토큰 가져오기
//            val token = task.result
//
//            val msg = "FCM Registration token: " + token;
//            Log.d("MainActivity", msg)
//            Toast.makeText(baseContext, msg, Toast.LENGTH_SHORT).show()
//        })
    }

}