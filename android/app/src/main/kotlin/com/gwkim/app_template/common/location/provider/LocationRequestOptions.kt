package com.gwkim.app_template.common.location.provider

import com.google.android.gms.location.LocationRequest

class LocationRequestOptions {
    val interval: Long = 5000
    val accuracy = LocationRequest.PRIORITY_HIGH_ACCURACY
    val distanceFilter:Float = 0.0F
}