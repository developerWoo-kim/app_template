package com.gwkim.app_template.app.auth.data

import com.google.gson.annotations.SerializedName

data class TokenResponse(
    @SerializedName("grantType") val grantType: String,
    @SerializedName("authorizationType") val authorizationType: String,
    @SerializedName("accessToken") val accessToken: String,
    @SerializedName("refreshToken") val refreshToken: String,
    @SerializedName("accessTokenExpiresIn") val accessTokenExpiresIn: Long
)
