package com.gwkim.app_template.common.refrofit.interceptor

import com.gwkim.app_template.app.auth.TokenRepository
import com.gwkim.app_template.common.api.ApiClient
import kotlinx.coroutines.flow.first
import kotlinx.coroutines.runBlocking
import okhttp3.*
import java.net.HttpURLConnection
import javax.inject.Inject

class HeaderInterceptor @Inject constructor(
    private val tokenRepository: TokenRepository
) : Interceptor{
    override fun intercept(chain: Interceptor.Chain): Response {
        val accessToken : String = runBlocking {
            tokenRepository.getPreference(TokenRepository.ACCESS_TOKEN_KEY).first()
        } ?: return errorResponse(chain.request())

        var response: Response
        if(!chain.request().header("accessToken").isNullOrEmpty()) {
            val tokenAddedRequest = chain.request().newBuilder()
                    .addHeader("authorization", "Bearer $accessToken" )
                    .addHeader("User-Agent-Platform", "ANDROID")
                    .build()

            response = chain.proceed(tokenAddedRequest);

            if (response.code == 401) {
                response.close()
                val newAccessToken = runBlocking {
                    val refreshToken = tokenRepository.getPreference(TokenRepository.REFRESH_TOKEN_KEY).first()
                    val accessTokenDto = refreshToken?.let { ApiClient.apiService.getAccessToken("Bearer $it") }
                    if (accessTokenDto != null) {
                        tokenRepository.setPreference(TokenRepository.ACCESS_TOKEN_KEY, accessTokenDto.accessToken)
                    }
                    accessTokenDto?.accessToken
                } ?: ""

                val newTokenAddedRequest = chain.request().newBuilder()
                        .addHeader("Authorization", "Bearer $newAccessToken")
                        .addHeader("User-Agent-Platform", "ANDROID")
                        .build()

                response = chain.proceed(newTokenAddedRequest)
            }
        } else {
            response = chain.proceed(chain.request())
        }

        return response
    }

    private fun errorResponse(request: Request): Response = Response.Builder()
            .request(request)
            .protocol(Protocol.HTTP_2)
            .code(401)
            .message("")
            .body(ResponseBody.create(null, ""))
            .build()
}