//package com.gwkim.app_template.common.firebase
//
//import android.app.NotificationChannel
//import android.app.NotificationManager
//import android.app.PendingIntent
//import android.content.Context
//import android.content.Intent
//import android.media.RingtoneManager
//import android.os.Build
//import android.util.Log
//import androidx.core.app.NotificationCompat
//import com.google.firebase.messaging.FirebaseMessagingService
//import com.google.firebase.messaging.RemoteMessage
//import com.gwkim.app_template.MainActivity
//
//class MyFirebaseMessagingService: FirebaseMessagingService() {
//
//    override fun onMessageReceived(message: RemoteMessage) {
//        super.onMessageReceived(message)
//        // 메시지에 데이터 페이로드가 포함 되어 있는지 확인한다.
//        // 페이로드란 전송된 데이터를 의미한다.
//        if (message.data.isNotEmpty()) {
//            Log.d("onMessageReceived", "Message data payload: ${message.data}")
//            sendNotification(
//                    message.data["title"].toString(),
//                    message.data["body"].toString()
//            )
//        } else {
//            // 메시지에 알림 페이로드가 포함되어 있는지 확인한다.
//            message.notification?.let {
//                sendNotification(
//                        message.notification!!.title.toString(),
//                        message.notification!!.body.toString()
//                )
//            }
//        }
//    }
//
//    // 새 토큰이 생성될 때마다 onNewToken 콜백이 호출된다.
//    // 등록 토큰이 처음 생성되므로 여기서 토큰을 검색할 수 있다.
//    override fun onNewToken(token: String) {
//        super.onNewToken(token)
//        sendRegistrationToServer(token)
//    }
//
//    // 메시지에 데이터 페이로드가 포함 되어 있을 때 실행되는 메서드
//    // 10초 이내로 걸릴 때 메시지를 처리한다.
//    private fun handleNow() {
//        Log.d("MyFirebaseMessagingService", "Short lived task is done.")
//    }
//
//    // 타사 서버에 토큰을 유지해주는 메서드이다.
//    private fun sendRegistrationToServer(token: String?) {
//        Log.d("MyFirebaseMessagingService", "sendRegistrationTokenToServer($token)")
//    }
//
//    // 수신 된 FCM 메시지를 포함하는 간단한 알림을 만들고 표시한다.
//    private fun sendNotification(title: String, body: String) {
//        val intent = Intent(this, MainActivity::class.java)
//        intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
//        val pendingIntent = PendingIntent.getActivity(
//                this, 0, intent,
//                PendingIntent.FLAG_IMMUTABLE
//        )
//
//        val channelId = "fcm_default_channel"
//        val defaultSoundUri = RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION)
//        val notificationBuilder = NotificationCompat.Builder(this, channelId)
////                .setSmallIcon(R.drawable.notification_icon)
//                .setContentTitle(title)
//                .setContentText(body)
//                .setAutoCancel(true)
//                .setSound(defaultSoundUri)
//                .setContentIntent(pendingIntent)
//
//        val notificationManager =
//                getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
//        // 오레오 이상에서 알림을 제공하려면 앱의 알림 채널을 시스템에 등록해야 한다.
//        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
//            val channel = NotificationChannel(
//                    channelId,
//                    "Channel human readable title",
//                    NotificationManager.IMPORTANCE_DEFAULT
//            )
//            notificationManager.createNotificationChannel(channel)
//        }
//
//        notificationManager.notify(0, notificationBuilder.build())
//    }
//}