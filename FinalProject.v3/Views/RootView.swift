//
//  RootView.swift
//  FinalProject.v2
//
//  Created by Nick Collins on 4/18/26.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import GoogleSignIn

struct RootView: View {
    @State private var isSignedIn = false
    @State private var needsUsername = false
    @State private var isLoading = true

    var body: some View {
        if isLoading {
            ProgressView()
                .onAppear {
                    let _ = Auth.auth().addStateDidChangeListener { _, user in
                        if let _ = user {
                            checkUserProfile()
                        } else {
                            isLoading = false
                        }
                    }
                }
        } else if isSignedIn && !needsUsername {
            HomeView()
        } else if isSignedIn && needsUsername {
            UsernameSetupView {
                needsUsername = false
            }
        } else {
            LoginView(onSignIn: {
                checkUserProfile()
            })
        }
    }

    func checkUserProfile() {
        guard let uid = Auth.auth().currentUser?.uid else {
            isLoading = false
            return
        }
        let db = Firestore.firestore()
        db.collection("users").document(uid).getDocument { doc, _ in
            isLoading = false
            if let doc = doc, doc.exists, let _ = doc.data()?["username"] {
                needsUsername = false
                isSignedIn = true
            } else {
                isSignedIn = true
                needsUsername = true
            }
        }
    }
}
