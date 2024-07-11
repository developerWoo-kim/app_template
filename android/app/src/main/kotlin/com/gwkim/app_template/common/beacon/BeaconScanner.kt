package com.gwkim.app_template.common.beacon

import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothManager
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanSettings
import android.content.Context
import android.media.SoundPool
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.widget.Toast
import com.gwkim.app_template.MyApplication
import com.gwkim.app_template.R
import com.gwkim.app_template.common.location.provider.*
import com.gwkim.app_template.driving.AutoDrivingOption
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking
import java.util.HashMap


class BeaconScanner(private val drivingOption: AutoDrivingOption) : LocationUpdateListener {
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
    private var maxFailure = 3
    private var failureCount = 0

    var isScan = false
    var scanResults: ArrayList<BluetoothDevice>? = ArrayList()

    private val scanCallback = object : ScanCallback() {
        override fun onScanResult(callbackType: Int, result: ScanResult) {
            super.onScanResult(callbackType, result)
            Log.d("BleScanner", "Scan result: ${result.device.address}")
            isScan = true
            failureCount = 0
            addScanResult(result)
            stopScan()
        }

        override fun onScanFailed(errorCode: Int) {
            super.onScanFailed(errorCode)
            Log.d("BleScanner", "Scan failed with error: $errorCode")
            // Increment failure count on scan failure
            failureCount++
            if (failureCount >= maxFailure) {
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

        val filters: MutableList<ScanFilter> = ArrayList()
        runBlocking {
            val beaconAddress = drivingOption.getBeaconAddress().first() ?: ""
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
                Log.d("BleScanner", "SCANNING MAX FAILURE COUNT :: $maxFailure")
                Log.d("BleScanner", "SCANNING FAILURE COUNT :: $failureCount")
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
                            isDriving = true;

                            var soundId : Int = 0
                            soundId = soundPool.load(context, R.raw.drive_start_audio, 1)
                            soundPool.setOnLoadCompleteListener { soundPool, sountId, status ->
                                if (status == 0) { // Status 0 means the sound was loaded successfully
                                    soundPool.play(soundId, 1f, 1f, 0, 0, 1f)
                                }
                            }

                            Toast.makeText(context, "애드럭과 함께 운행이 시작되었습니다!", Toast.LENGTH_SHORT).show();
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
        failureCount = 0;
        isScan = false;
        isLocationRunning = false;
        isDriving = false;
    }

    private fun handleScanFailure() {
        Log.d("BleScanner", "Scan result: false")
        if(isDriving) {
            failureCount++
            if(failureCount >= maxFailure) {
                locatorClient?.removeLocationUpdates()
                isLocationRunning = false
                isDriving = false

                var soundId : Int = 0
                soundId = soundPool.load(context, R.raw.drive_end_audio, 1)
                soundPool.setOnLoadCompleteListener { soundPool, sountId, status ->
                    if (status == 0) { // Status 0 means the sound was loaded successfully
                        soundPool.play(soundId, 1f, 1f, 0, 0, 1f)
                    }
                }

                Toast.makeText(context, "운행이 종료되었습니다.", Toast.LENGTH_SHORT).show();
            }
        }
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
            Log.d("onLocationUpdated", "onLocationUpdated ::::: $result")
        }
    }
}