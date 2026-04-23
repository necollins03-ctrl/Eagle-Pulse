//
//  UsernameSetupView.swift
//  FinalProject.v2
//
//  Created by Nick Collins on 4/18/26.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore

struct UsernameSetupView: View {
    var onComplete: () -> Void
    @State private var username = ""
    @State private var errorMessage: String? = nil
    @State private var isLoading = false

    var body: some View {
        ZStack {
            Color("blackBC")
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 20) {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 70, height: 70)
                        .foregroundStyle(Color("maroonBC"))

                    Text("Choose a Username")
                        .font(.custom("BebasNeue-Regular", size: 36))
                        .foregroundStyle(Color("goldBC"))

                    Rectangle()
                        .frame(width: 160, height: 1.5)
                        .foregroundStyle(Color("goldBC").opacity(0.5))

                    Text("This is how other BC students will see you.")
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                        .bold()
                }

                Spacer()

                VStack(spacing: 16) {
                    TextField("Username", text: $username)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                        .foregroundStyle(.white)
                        .padding(14)
                        .background(Color.white.opacity(0.07))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("goldBC").opacity(0.3), lineWidth: 1)
                        )
                        .padding(.horizontal, 32)

                    if let error = errorMessage {
                        Text(error)
                            .foregroundStyle(.red)
                            .font(.caption)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                    }

                    Button(action: saveUsername) {
                        if isLoading {
                            ProgressView()
                                .tint(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else {
                            Text("Continue")
                                .fontWeight(.semibold)
                                .foregroundStyle(username.isEmpty ? .white.opacity(0.4) : Color("goldBC"))
                                .frame(maxWidth: .infinity)
                                .padding()
                        }
                    }
                    .background(username.isEmpty ? Color.white.opacity(0.07) : Color("maroonBC"))
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(username.isEmpty ? Color.white.opacity(0.1) : Color("goldBC").opacity(0.4), lineWidth: 1)
                    )
                    .padding(.horizontal, 32)
                    .disabled(username.isEmpty || isLoading)
                }

                Spacer().frame(height: 60)
            }
        }
    }

    func saveUsername() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let trimmed = username.trimmingCharacters(in: .whitespaces)

        guard trimmed.count >= 3 else {
            errorMessage = "Username must be at least 3 characters."
            return
        }

        isLoading = true
        let db = Firestore.firestore()

        db.collection("users").whereField("username", isEqualTo: trimmed).getDocuments { snapshot, _ in
            if let snapshot = snapshot, !snapshot.isEmpty {
                errorMessage = "That username is already taken."
                isLoading = false
                return
            }

            let email = Auth.auth().currentUser?.email ?? ""
            db.collection("users").document(uid).setData([
                "username": trimmed,
                "email": email,
                "createdAt": Timestamp()
            ]) { error in
                isLoading = false
                if let error = error {
                    errorMessage = error.localizedDescription
                } else {
                    onComplete()
                }
            }
        }
    }
}

#Preview {
    UsernameSetupView(onComplete: {})
}
