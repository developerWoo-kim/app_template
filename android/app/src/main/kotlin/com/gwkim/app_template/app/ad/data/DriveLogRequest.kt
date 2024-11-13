package com.gwkim.app_template.app.ad.data

import com.google.gson.annotations.SerializedName

data class DriveLogRequest(
    @SerializedName("adSn") val adSn:String,
    @SerializedName("data") val data:List<LocationData>
)

data class LocationData(
    @SerializedName("latitude") val latitude:Double,
    @SerializedName("longitude") val longitude:Double,
    @SerializedName("sttscd") val sttscd:String,
    @SerializedName("time") val time:Double,
)
