//
//  CollabCardsApp.swift
//  CollabCards
//
//  Created by FFK on 24.07.2024.
//

import SwiftUI
import SwiftData
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct CollabCardsApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    
    let modelContainer: ModelContainer
    
    init() {
        do {
            modelContainer = try ModelContainer(for: Board.self)
        } catch {
            fatalError("Could not initialize ModelContainer")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Board.self)
    }
}

