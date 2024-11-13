package com.gwkim.app_template.app.driving

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.pm.ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION
import android.media.SoundPool
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import androidx.annotation.RequiresApi
import androidx.core.app.NotificationCompat
import androidx.work.CoroutineWorker
import androidx.work.ForegroundInfo
import androidx.work.WorkManager
import androidx.work.WorkerParameters
import com.gwkim.app_template.MyApplication
import com.gwkim.app_template.R
import com.gwkim.app_template.common.location.provider.BLLocationProvider
import com.gwkim.app_template.common.timer.TimerHandler
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

class BatteryWorker(context: Context, parameters: WorkerParameters): CoroutineWorker(context, parameters) {
    private val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    var runningAdSn: String = ""
    val soundPool: SoundPool = SoundPool.Builder().build()
    private var context: Context = MyApplication.applicationContext()
    private var locatorClient: BLLocationProvider? = null
    private var isLocationRunning = false;
    private var isDriving = false;

    private var connectMaxFailureCount = 3
    private var connectFailureCount = 0

    private val drivingEndHandler = Handler(Looper.getMainLooper())

    private val monitoringHandler = Handler(Looper.getMainLooper())
    private val monitoringInterval: Long = 5000 // 10 seconds

    companion object {
        private val channelId = "workerManagerChannel"
    }

    override suspend fun doWork(): Result {
//        val inputUrl = inputData.getString(KEY_INPUT_URL)
//                ?: return Result.failure()
//        val outputFile = inputData.getString(KEY_OUTPUT_FILE_NAME)
//                ?: return Result.failure()
        // Mark the Worker as important
        val progress = "Starting Download"
        setForeground(createForegroundInfo(progress))
//        download(inputUrl, outputFile)
        TimerHandler.startTimer()
        Log.d("BatteryWorker", "BatteryWorker START")

        return Result.retry()
    }

    private fun download(inputUrl: String, outputFile: String) {
        // Downloads a file and updates bytes read
        // Calls setForeground() periodically when it needs to update
        // the ongoing Notification
    }
    // Creates an instance of ForegroundInfo which can be used to update the
    // ongoing notification.
    private fun createForegroundInfo(progress: String): ForegroundInfo {
//        val id = applicationContext.getString(R.string.notification_channel_id)
//        val title = applicationContext.getString(R.string.notification_title)
//        val cancel = applicationContext.getString(R.string.cancel_download)
//        // This PendingIntent can be used to cancel the worker
        val intent = WorkManager.getInstance(applicationContext)
                .createCancelPendingIntent(getId())

        // Create a Notification channel if necessary
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            createChannel()
        }

//        val notificationIntent = Intent(applicationContext, MainActivity::class.java)
//        val pendingIntent = PendingIntent.getActivity(applicationContext, 0, notificationIntent, PendingIntent.FLAG_IMMUTABLE)
        val notification: Notification = NotificationCompat.Builder(applicationContext, channelId)
                .setContentTitle("애드럭과 beacon scanning...")
                .setContentText(progress)
                .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
                .setPriority(NotificationCompat.PRIORITY_HIGH)
                .setOngoing(true)
                .setSmallIcon(R.drawable.navermap_default_cluster_icon_medium_density) // Add your own notification icon here
                .setContentIntent(intent)
                .build()

        return ForegroundInfo(102, notification, FOREGROUND_SERVICE_TYPE_LOCATION)
    }

    @RequiresApi(Build.VERSION_CODES.O)
    private fun createChannel() {
        // Create a Notification channel
        val serviceChannel = NotificationChannel(
                channelId,
                "Bluetooth Service Channel",
                NotificationManager.IMPORTANCE_HIGH
        )
        notificationManager.createNotificationChannel(serviceChannel)
    }
}