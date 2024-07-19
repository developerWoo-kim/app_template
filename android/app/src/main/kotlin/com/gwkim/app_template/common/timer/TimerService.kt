package com.gwkim.app_template.common.timer

import android.app.Service
import android.content.Intent
import android.os.Binder
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.SystemClock
import android.util.Log

class TimerService : Service() {

    private val binder = LocalBinder()
    private val handler = Handler(Looper.getMainLooper())
    private var startTime: Long = 0
    private var elapsedTime: Long = 0
    private var isRunning = false

    override fun onCreate() {
        super.onCreate()
        Log.d("TimerService", "::::: Timer Service Start!!!!");
        startTimer()
    }


    inner class LocalBinder : Binder() {
        fun getService(): TimerService = this@TimerService
    }

    override fun onBind(intent: Intent): IBinder {
        return binder
    }

    private fun startTimer() {
        startTime = SystemClock.elapsedRealtime()
        isRunning = true
        handler.post(tickRunnable)
    }

    fun stopTimer() {
        isRunning = false
        handler.removeCallbacks(tickRunnable)
    }

    fun getElapsedTime(): Long {
        return if (isRunning) {
            SystemClock.elapsedRealtime() - startTime
        } else {
            elapsedTime
        }
    }

    private val tickRunnable = object : Runnable {
        override fun run() {
            if (isRunning) {
                elapsedTime = SystemClock.elapsedRealtime() - startTime

                Log.d("TimerService", elapsedTime.toString());
                // Send elapsed time to Flutter
                // Implement method to send data to Flutter
                handler.postDelayed(this, 1000)
            }
        }
    }
}