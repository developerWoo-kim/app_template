package com.gwkim.app_template.common.location.provider

import kotlinx.coroutines.CoroutineDispatcher
import okhttp3.ResponseBody
import java.util.HashMap

interface LocationUpdateListener {
    fun onLocationUpdated(location: HashMap<Any, Any>?)
}