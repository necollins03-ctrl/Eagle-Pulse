//
//  FinalProject_v2App.swift
//  FinalProject.v2
//
//  Created by Nick Collins on 4/17/26.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn

@main
struct FinalProjectApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            RootView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
