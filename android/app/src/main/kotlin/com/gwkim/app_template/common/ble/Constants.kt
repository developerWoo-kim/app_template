package kr.co.dpub.dpubadd.common.ble

import android.Manifest

// used to identify adding bluetooth names
const val REQUEST_ENABLE_BT = 1
// used to request fine location permission
const val REQUEST_ALL_PERMISSION = 2
val PERMISSIONS = arrayOf(
        Manifest.permission.ACCESS_FINE_LOCATION
)

//사용자 BLE UUID Service/Rx/Tx ABCDEF00-1000-1000-1000-A1B2C3D4E5F6
const val SERVICE_STRING = "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"
const val CHARACTERISTIC_COMMAND_STRING = "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"
const val CHARACTERISTIC_RESPONSE_STRING = "E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"

//BluetoothGattDescriptor 고정
const val CLIENT_CHARACTERISTIC_CONFIG = "00002902-0000-1000-8000-00805f9b34fb"