//package com.gwkim.app_template.common.refrofit.interceptor
//
//import com.gwkim.app_template.MainActivity
//import com.gwkim.app_template.app.auth.TokenRepository
//import kotlinx.coroutines.flow.first
//import kotlinx.coroutines.runBlocking
//import okhttp3.*
//import javax.inject.Inject
//
//class AuthInterceptor @Inject constructor(
//    private val tokenRepository: TokenRepository
//) : Authenticator {
//    override fun authenticate(route: Route?, response: Response): Request? {
//        val originRequest = response.request
//
//        if(originRequest.header("Authorization").isNullOrEmpty()){
//            return null
//        }
//
//        if(response.code == 401) {
//            val refreshToken : String = runBlocking {
//                tokenRepository.getPreference(TokenRepository.REFRESH_TOKEN_KEY).first()
//            } ?: ""
//
//            if(refreshToken == "") {
//                response.close()
//                return null
//            }
//
//            val build: Request = response.request.newBuilder()
//                    .url("https://www.dpub.com/api/v1/auth/token")
//                    .removeHeader("Authorization")
//                    .addHeader("Refresh", "Bearer $refreshToken")
//                    .build()
//        }
//
//
//
//
//
//    }
//
//    private fun newRequestWithRefreshToken(token: String, request: Request): Request =
//            request.newBuilder()
//                    .header("Refresh", token)
//                    .build()
//
//}