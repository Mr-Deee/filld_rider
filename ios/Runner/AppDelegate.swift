
import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging
import GoogleMaps
import UserNotifications








import Flutter
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyC6UDM8O3wlMa5SNLHfcM8MGEFJ3ejc55U")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
//
// @main
// @objc class AppDelegate: FlutterAppDelegate {
//     override func application(
//         _ application: UIApplication,
//         didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//     ) -> Bool {
//         // Initialize Firebase
//         FirebaseApp.configure()
//
//         // Set UNUserNotificationCenter delegate
//         UNUserNotificationCenter.current().delegate = self
//
//         // Request push notification permissions
//         requestNotificationPermissions(application)
//
//         return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//     }
//
//     func requestNotificationPermissions(_ application: UIApplication) {
//         let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//         UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
//             if granted {
//                 print("Notification permission granted")
//                 DispatchQueue.main.async {
//                     application.registerForRemoteNotifications()
//                 }
//             } else {
//                 print("Notification permission denied: \(error?.localizedDescription ?? "unknown error")")
//             }
//         }
//     }
//
//     override func application(
//         _ application: UIApplication,
//         didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
//     ) {
//         print("APNs token received: \(deviceToken)")
//         Messaging.messaging().apnsToken = deviceToken
//         super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
//     }
// }


//@main
//@objc class AppDelegate: FlutterAppDelegate {
//    override func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
//    ) -> Bool {
//        // Initialize Firebase
//        if FirebaseApp.app() == nil {
//            FirebaseApp.configure()
//        } else {
//            print("Firebase is already configured")
//        }
//
//        // Provide Google Maps API Key
//        GMSServices.provideAPIKey("AIzaSyC6UDM8O3wlMa5SNLHfcM8MGEFJ3ejc55U")
//
//        // Set UNUserNotificationCenter delegate
//        UNUserNotificationCenter.current().delegate = self
//
//        // Register for push notifications
//        requestNotificationPermissions(application)
//
//        // Register plugins
//        GeneratedPluginRegistrant.register(with: self)
//
//        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//    }
//
//    func requestNotificationPermissions(_ application: UIApplication) {
//        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
//        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { granted, error in
//            if granted {
//                print("Notification permission granted")
//                DispatchQueue.main.async {
//                    application.registerForRemoteNotifications()
//                }
//            } else {
//                print("Notification permission denied: \(error?.localizedDescription ?? "unknown error")")
//            }
//        }
//    }
//
//    override func application(
//        _ application: UIApplication,
//        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
//    ) {
//        print("APNs token received: \(deviceToken)")
//        Messaging.messaging().apnsToken = deviceToken
//        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
//    }
//}
