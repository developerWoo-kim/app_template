package com.gwkim.app_template.common.api

import com.gwkim.app_template.app.ad.data.DriveLogRequest
import com.gwkim.app_template.app.auth.data.AccessTokenResponse
import okhttp3.Response
import okhttp3.ResponseBody
import retrofit2.http.Body
import retrofit2.http.GET
import retrofit2.http.Header
import retrofit2.http.POST

interface ApiService {
    @POST("/api/v1/auth/token")
    suspend fun getAccessToken(@Header("Authorization") refreshToken:String): AccessTokenResponse


    @GET("/auth/login")
    suspend fun login(): AccessTokenResponse

    @GET("/api/v1/user")
    suspend fun getUser(@Header("accessToken") accessToken: String): ResponseBody

    @POST("/api/v1/ad/drive-log")
    suspend fun sendDriveLog(@Header("accessToken") accessToken: String, @Body driveLog:DriveLogRequest): ResponseBody

    @POST("/api/v1/ad/drive-log/force-quit")
    suspend fun forceQuitDriveLog(@Header("accessToken") accessToken: String): ResponseBody
}