package com.gwkim.app_template.common.di

import android.content.Context
import com.gwkim.app_template.common.beacon.BeaconScanner
import com.gwkim.app_template.driving.AutoDrivingOption
import kr.co.dpub.dpubadd.common.ble.BluetoothRepository
import org.koin.core.scope.get
import org.koin.dsl.module

val repositoryModule = module{
    single{
        BluetoothRepository()
    }
}

val beaconScannerModule = module{
    single {
        val context: Context = get()
        AutoDrivingOption(context)
    }

    single {
        BeaconScanner(get())
    }
}
