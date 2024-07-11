package com.gwkim.app_template.common.ble

import android.app.*
import android.content.Intent
import android.location.LocationManager
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import com.gwkim.app_template.MainActivity
import com.gwkim.app_template.MyApplication
import com.gwkim.app_template.R
import org.koin.android.ext.android.inject
import kr.co.dpub.dpubadd.common.ble.BluetoothRepository

class BluetoothService : Service() {

    private val bluetoothRepository: BluetoothRepository by inject()

//    private val locationManager: LocationManager =
//            MyApplication.applicationContext().getSystemService(LOCATION_SERVICE) as LocationManager
    override fun onCreate() {
        super.onCreate()
//        bluetoothRepository.startScan()

    }
    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}