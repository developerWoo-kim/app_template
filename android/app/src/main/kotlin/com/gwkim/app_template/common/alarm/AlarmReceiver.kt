package com.gwkim.app_template.common.alarm

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.graphics.Color
import android.os.Build
import android.util.Log
import android.widget.Toast
import androidx.core.app.NotificationCompat
import com.gwkim.app_template.MainActivity
import com.gwkim.app_template.R
import com.gwkim.app_template.app.driving.AutoDrivingService

class AlarmReceiver : BroadcastReceiver() {

    companion object {
        const val TAG = "AlarmReceiver"
//        const val NOTIFICATION_ID = 0
//        const val PRIMARY_CHANNEL_ID = "primary_notification_channel"
    }

//    lateinit var notificationManager: NotificationManager

    override fun onReceive(context: Context, intent: Intent) {
        Log.d(TAG, "Received intent : $intent")
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val intent = Intent(context, AutoDrivingService::class.java)
            intent.action = AutoDrivingService.ACTION_STOP_DRIVING
            context?.startForegroundService(intent)
        } else {
            val intent = Intent(context, AutoDrivingService::class.java)
            intent.action = AutoDrivingService.ACTION_STOP_DRIVING
            context?.startService(Intent(context, AutoDrivingService::class.java))
        }
//        notificationManager = context.getSystemService(
//                Context.NOTIFICATION_SERVICE) as NotificationManager

//        createNotificationChannel()
//        deliverNotification(context)
    }

//    private fun deliverNotification(context: Context) {
//        val contentIntent = Intent(context, MainActivity::class.java)
//        val contentPendingIntent = PendingIntent.getActivity(
//                context,
//                NOTIFICATION_ID,
//                contentIntent,
//                PendingIntent.FLAG_UPDATE_CURRENT
//        )
//        val builder =
//                NotificationCompat.Builder(context, PRIMARY_CHANNEL_ID)
//                        .setSmallIcon(R.drawable.common_google_signin_btn_icon_dark)
//                        .setContentTitle("Alert")
//                        .setContentText("This is repeating alarm")
//                        .setContentIntent(contentPendingIntent)
//                        .setPriority(NotificationCompat.PRIORITY_HIGH)
//                        .setAutoCancel(true)
//                        .setDefaults(NotificationCompat.DEFAULT_ALL)
//
//        notificationManager.notify(NOTIFICATION_ID, builder.build())
//    }
//
//    fun createNotificationChannel() {
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val notificationChannel = NotificationChannel(
//                    PRIMARY_CHANNEL_ID,
//                    "Stand up notification",
//                    NotificationManager.IMPORTANCE_HIGH
//            )
//            notificationChannel.enableLights(true)
//            notificationChannel.lightColor = Color.RED
//            notificationChannel.enableVibration(true)
//            notificationChannel.description = "AlarmManager Tests"
//            notificationManager.createNotificationChannel(
//                    notificationChannel)
//        }
//    }
}