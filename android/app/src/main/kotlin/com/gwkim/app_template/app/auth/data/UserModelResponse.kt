package com.gwkim.app_template.app.auth.data

import com.google.gson.annotations.SerializedName

data class UserModelResponse(
    @SerializedName("userId") val userId: String,
    @SerializedName("runningAdSn") val runningAdSn: String,
)
