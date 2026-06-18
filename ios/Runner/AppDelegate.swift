import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate, MessagingDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()

    // Required when FirebaseAppDelegateProxyEnabled = false:
    // Firebase cannot auto-swizzle, so we must set the delegate manually.
    Messaging.messaging().delegate = self

    // Flutter assets live inside App.framework, not the main bundle.
    let apiKey = loadApiKeyFromAppFramework() ?? "AIzaSyDGX7shxM5innSSWRMX7PvNHCc33dJ4zsE"
    GMSServices.provideAPIKey(apiKey)

    GeneratedPluginRegistrant.register(with: self)

    // Request notification permissions
    UNUserNotificationCenter.current().delegate = self
    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { _, _ in }
    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // MARK: - APNs token → Firebase
  // Required when FirebaseAppDelegateProxyEnabled = false.
  // Without this, Firebase never gets the APNs token and cannot produce an FCM token.
  override func application(
    _ application: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    Messaging.messaging().apnsToken = deviceToken
    super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
  }

  override func application(
    _ application: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("❌ APNs registration failed: \(error.localizedDescription)")
  }

  // MARK: - MessagingDelegate
  func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
    print("✅ FCM token: \(fcmToken ?? "nil")")
    // The Flutter firebase_messaging plugin handles token delivery to Dart via its own channel.
  }

  // MARK: - UNUserNotificationCenterDelegate
  // Show notifications while the app is in the foreground.
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    if #available(iOS 14.0, *) {
      completionHandler([.banner, .badge, .sound])
    } else {
      completionHandler([.alert, .badge, .sound])
    }
  }

  // Handle notification tap (app in background or terminated).
  override func userNotificationCenter(
    _ center: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completionHandler: @escaping () -> Void
  ) {
    super.userNotificationCenter(center, didReceive: response, withCompletionHandler: completionHandler)
  }

  // MARK: - Google Maps API key loader
  private func loadApiKeyFromAppFramework() -> String? {
    let bundlePath = Bundle.main.bundlePath
    let envFiles = [".env.dev", ".env.prod"]

    for fileName in envFiles {
      let path = "\(bundlePath)/Frameworks/App.framework/flutter_assets/\(fileName)"
      if let content = try? String(contentsOfFile: path, encoding: .utf8) {
        for line in content.components(separatedBy: .newlines) {
          if line.hasPrefix("GOOGLE_MAPS_API_KEY=") {
            let key = String(line.dropFirst("GOOGLE_MAPS_API_KEY=".count))
              .trimmingCharacters(in: .whitespaces)
            if !key.isEmpty && !key.contains("$(") {
              return key
            }
          }
        }
      }
    }
    return nil
  }
}
