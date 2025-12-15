import Flutter
import UIKit
import Firebase
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate,MessagingDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {

FirebaseApp.configure()

    // FCM delegate
    Messaging.messaging().delegate = self

    // Register for APNs
    application.registerForRemoteNotifications()

       
 GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  // FCM token callback
  func messaging(_ messaging: Messaging,
                 didReceiveRegistrationToken fcmToken: String?) {
    print("🔥 FCM Token:", fcmToken ?? "nil")
  }

}
