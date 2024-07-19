package com.gwkim.app_template.common.timer

import android.os.Handler
import android.os.Looper
import android.os.SystemClock
import android.util.Log
import io.flutter.plugin.common.EventChannel

object TimerHandler : EventChannel.StreamHandler {

    private var eventSink: EventChannel.EventSink? = null
    private val handler = Handler(Looper.getMainLooper())
    private var startTime: Long = 0
    private var elapsedTime: Long = 0
    private var isRunning = false
    override fun onListen(arguments: Any?, sink: EventChannel.EventSink?) {
        eventSink = sink
    }

    override fun onCancel(arguments: Any?) {
        eventSink = null
    }

    fun startTimer() {
        startTime = SystemClock.elapsedRealtime()
        isRunning = true
        handler.post(tickRunnable)
    }

    fun stopTimer() {
        isRunning = false
        val drivingStatus = mapOf<String, Any>(
                "time" to elapsedTime,
                "isRunning" to isRunning
        )
        eventSink?.success(drivingStatus)
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
                if(eventSink != null) {
                    val drivingStatus = mapOf<String, Any>(
                        "time" to elapsedTime,
                        "isRunning" to isRunning
                    )
                    eventSink?.success(drivingStatus)
                }
                // Send elapsed time to Flutter
                // Implement method to send data to Flutter
                handler.postDelayed(this, 1000)
            }
        }
    }
}