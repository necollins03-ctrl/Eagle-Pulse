//
//  FinalProject_v2App.swift
//  FinalProject.v2
//
//  Created by Nick Collins on 4/17/26.
//

import SwiftUI
import FirebaseCore

@main
struct FinalProject_v2App: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
