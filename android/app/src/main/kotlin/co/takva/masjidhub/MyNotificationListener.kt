package co.takva.masjidhub

import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import io.flutter.plugin.common.MethodChannel

public class MyNotificationListener : NotificationListenerService() {

    public companion object {
        public var notificationChannel: MethodChannel? = null
    }

    public override fun onNotificationPosted(sbn: StatusBarNotification) {
        val packageName = sbn.packageName
        if (packageName != "com.whatsapp") {
            return
        }

        val extras = sbn.notification.extras
        val title = extras.getString("android.title") ?: ""
        val text = extras.getCharSequence("android.text")?.toString() ?: ""

        Log.d("MyNotificationListener", "WhatsApp Notification received: $title - $text")

        notificationChannel?.invokeMethod(
            "onNotification",
            mapOf("title" to title, "body" to text)
        )
    }

}
