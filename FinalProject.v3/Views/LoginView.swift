//
//  LoginView.swift
//  FinalProject.v2
//
//  Created by Nick Collins on 4/18/26.
//

import SwiftUI
import Firebase
import FirebaseAuth
import GoogleSignIn

struct LoginView: View {
    var onSignIn: () -> Void
    @State private var errorMessage: String? = nil
    
    var body: some View {
        ZStack {
            Color("blackBC")
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // Logo + Title
                VStack(spacing: 20) {
                    Image("eagleLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 400)
                    
                    Text("EAGLE PULSE")
                        .font(.custom("BebasNeue-Regular", size: 60))
                        .foregroundStyle(.white)
                        .bold()
                    
                    Rectangle()
                        .frame(width: 160, height: 1.5)
                        .foregroundColor(Color("goldBC").opacity(0.6))
                                        
                    Text("Know Before You Go")
                        .font(.custom("BebasNeue-Regular", size: 30))
                        .foregroundColor(Color("goldBC").opacity(0.8))
                        .bold()
                    
                }
                
                Spacer()
                
                // Sign In Button
                Button(action: signInWithGoogle) {
                    HStack(spacing: 12) {
                        Image(systemName: "person.crop.circle.badge.checkmark")
                            .foregroundColor(Color("goldBC"))
                        Text("Sign in with BC Email")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color("maroonBC"))
                    .cornerRadius(12)
                }
                .padding(.horizontal, 32)
                
                if let error = errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .padding(.top, 12)
                }
                
                Spacer()
            }
        }
    }
    
    func signInWithGoogle() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController else { return }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootVC) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
                return
            }
            
            guard let user = result?.user,
                  let idToken = user.idToken?.tokenString else { return }
            
            let credential = GoogleAuthProvider.credential(
                withIDToken: idToken,
                accessToken: user.accessToken.tokenString
            )
            
            let email = user.profile?.email ?? ""
            guard email.hasSuffix("@bc.edu") else {
                errorMessage = "You must sign in with a @bc.edu email."
                try? Auth.auth().signOut()
                return
            }
            
            Auth.auth().signIn(with: credential) { _, error in
                if let error = error {
                    errorMessage = error.localizedDescription
                    return
                }
                onSignIn()
            }
        }
    }
}

#Preview {
    LoginView(onSignIn: {})
}
