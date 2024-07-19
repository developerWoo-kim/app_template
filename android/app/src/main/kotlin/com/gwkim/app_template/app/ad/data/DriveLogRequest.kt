package com.gwkim.app_template.app.ad.data

data class DriveLogRequest(
    val adSn:String,
    val data:List<LocationData>
)

data class LocationData(
    val latitude:Double,
    val longitude:Double,
    val sttscd:String,
    val time:Double,
)
