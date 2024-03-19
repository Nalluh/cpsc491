//
//  CPSC491App.swift
//  CPSC491
//
//  Created by Allan Cortes on 1/29/24.
//

import SwiftUI
import Firebase
import FirebaseAuth



@main
struct CPSC491App: App {
 
    @State private var data = DataHandler()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            TopView()
                .environment(\.managedObjectContext, data.container.viewContext)
        }
    }
}


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()
    return true
  }
}
