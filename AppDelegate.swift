//
//  AppDelegate.swift
//  Neighborhood Connect
//
//  Created by Andy Delgado on 7/9/24.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
  // Configures Firebase when the app finishes launching
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}

@main
struct YourApp: App {
  // Registers app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

  var body: some Scene {
    WindowGroup {
      // Sets ContentView as the initial view of the app
      NavigationView {
        ContentView()
      }
    }
  }
}

