package com.gwkim.app_template.common.api

import com.gwkim.app_template.MyApplication
import com.gwkim.app_template.app.auth.TokenRepository
import com.gwkim.app_template.common.refrofit.interceptor.HeaderInterceptor
import okhttp3.OkHttpClient
import retrofit2.Retrofit
import retrofit2.converter.gson.GsonConverterFactory

object ApiClient {
    private const val BASE_URL = "https://www.dpubad.com"
    private lateinit var tokenRepository:TokenRepository

    private val okHttpClient: OkHttpClient by lazy {
        tokenRepository = MyApplication.tokenRepository
        OkHttpClient.Builder()
                .addInterceptor(HeaderInterceptor(tokenRepository))
                .build()
    }

    val retrofit: Retrofit by lazy {
        Retrofit.Builder()
                .baseUrl(BASE_URL)
                .client(okHttpClient)
                .addConverterFactory(GsonConverterFactory.create())
                .build()
    }

    val apiService: ApiService by lazy {
        retrofit.create(ApiService::class.java)
    }
}