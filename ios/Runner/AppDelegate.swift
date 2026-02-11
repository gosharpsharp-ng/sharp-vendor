import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()

    // Load Google Maps API key from .env files in flutter_assets
    if let apiKey = loadApiKey() {
      GMSServices.provideAPIKey(apiKey)
    }

    GeneratedPluginRegistrant.register(with: self)

    // Register for push notifications
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    application.registerForRemoteNotifications()

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func loadApiKey() -> String? {
    // Try .env.dev and then .env.prod in the flutter_assets folder
    let envFiles = [".env.dev", ".env.prod"]
    for fileName in envFiles {
      // Find the path to the asset in the main bundle
      if let path = Bundle.main.path(forResource: "flutter_assets/\(fileName)", ofType: nil) {
        do {
          let content = try String(contentsOfFile: path, encoding: .utf8)
          let lines = content.components(separatedBy: .newlines)
          for line in lines {
            if line.hasPrefix("GOOGLE_MAPS_API_KEY=") {
              let key = String(line.dropFirst("GOOGLE_MAPS_API_KEY=".count)).trimmingCharacters(in: .whitespaces)
              if !key.isEmpty && !key.contains("$(") {
                return key
              }
            }
          }
        } catch {
          print("Error loading \(fileName): \(error)")
        }
      }
    }
    return nil
  }
}