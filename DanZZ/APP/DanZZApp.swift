//
//  DanZZApp.swift
//  DanZZ
//
//  Created by Hong Lu on 27/11/2025.
//

import SwiftUI
import Firebase
import FirebaseAppCheck

// Use App Attest for the highest security on supporting devices (iOS 14.0+)
class AppAttestProviderFactory: NSObject, AppCheckProviderFactory {
    
    // Creates the AppAttestProvider instance
    func createProvider(with app: FirebaseApp) -> AppCheckProvider? {
        if #available(iOS 14.0, *) {
            // Use AppAttestProvider for iOS 14.0+
            return AppAttestProvider(app: app)
        } else {
            // Fallback for older systems, or return nil
            return DeviceCheckProvider(app: app)
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      let providerFactory = AppAttestProviderFactory()
      AppCheck.setAppCheckProviderFactory(providerFactory)
      FirebaseApp.configure()

      return true
  }
}


@main
struct DanZZApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var localeManager = LocalManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(localeManager)
                .environment(\.locale, localeManager.currentLocale)
        }
    }
}
