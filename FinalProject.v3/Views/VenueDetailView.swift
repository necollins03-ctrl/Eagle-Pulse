//
//  VenueDetailView.swift
//  FinalProject.v1
//
//  Created by Nick Collins on 4/17/26.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct VenueDetailView: View {
    var venue: Venue
    var store: VenueStore
    @State private var showUpdateView = false
    @State private var isGoing = false
    @State private var showGoingUsers = false
    @State private var goingUsers: [String] = []
    @State private var currentUsername: String = ""

    var hasEntryForToday: Bool {
        Calendar.current.isDateInToday(venue.lastUpdated)
    }

    var body: some View {
        ZStack {
            Color("blackBC")
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 24) {

                    // Header
                    VStack(alignment: .leading, spacing: 4) {
                        Text(venue.name)
                            .font(.custom("BebasNeue-Regular", size: 42))
                            .foregroundStyle(Color("goldBC"))
                        Text(venue.neighborhood)
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding(.horizontal)

                    // Status Tiles or No Entry
                    if hasEntryForToday {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            StatusTile(label: "Line", value: venue.lineStatus)
                            StatusTile(label: "Crowd", value: venue.crowdLevel)
                            StatusTile(label: "Cover", value: venue.coverStatus)
                            StatusTile(label: "Entry", value: venue.entryStatus)
                        }
                        .padding(.horizontal)

                        // Note
                        if let note = venue.note, !note.isEmpty {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Eagles are saying:")
                                    .font(.custom("BebasNeue-Regular", size: 32))
                                    .foregroundStyle(Color("goldBC"))
                                Text(note)
                                    .font(.title2)
                                    .foregroundStyle(.white.opacity(0.8))
                            }
                            .padding(.horizontal)
                            .padding(.top, -8)
                        }
                        
                        // Last updated
                        Text("Last updated \(venue.lastUpdated.formatted(.relative(presentation: .named)))")
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.5))
                            .padding(.horizontal)
                    } else {
                        Text("No entry for tonight yet.")
                            .foregroundStyle(.white.opacity(0.4))
                            .padding(.horizontal)
                    }
                    // I'm Going Button
                    VStack(alignment: .leading, spacing: 12) {
                        Button(action: toggleGoing) {
                            HStack {
                                Image(systemName: isGoing ? "checkmark.circle.fill" : "figure.walk")
                                Text(isGoing ? "You're going!" : "I'm going here tonight")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isGoing ? Color("maroonBC") : Color.white.opacity(0.1))
                            .foregroundStyle(isGoing ? Color("goldBC") : .white)
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isGoing ? Color("goldBC").opacity(0.4) : Color.white.opacity(0.15), lineWidth: 1)
                            )
                        }
                        .padding(.horizontal)

                        // Who's going
                        if !goingUsers.isEmpty {
                            let summary: String = {
                                if goingUsers.count == 1 {
                                    return "\(goingUsers[0]) is going tonight"
                                } else {
                                    return "\(goingUsers[0]) and \(goingUsers.count - 1) others are going tonight"
                                }
                            }()

                            Text(summary)
                                .font(.subheadline)
                                .foregroundStyle(Color("goldBC").opacity(0.8))
                                .padding(.horizontal)
                                .onTapGesture {
                                    showGoingUsers = true
                                }
                        }
                    }

                    // Confirm / Update Buttons
                    HStack(spacing: 12) {
                        Button("Confirm") {
                            store.confirmVenue(venue: venue)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("maroonBC").opacity(0.2))
                        .foregroundStyle(Color("maroonBC"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("maroonBC").opacity(0.4), lineWidth: 1)
                        )

                        Button("Update") {
                            showUpdateView = true
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color("goldBC").opacity(0.15))
                        .foregroundStyle(Color("goldBC"))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("goldBC").opacity(0.3), lineWidth: 1)
                        )
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("blackBC"), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .fullScreenCover(isPresented: $showUpdateView) {
            NavigationStack {
                UpdateView(venue: venue, store: store)
            }
        }
        .sheet(isPresented: $showGoingUsers) {
            GoingUsersView(users: goingUsers)
        }
        .onAppear {
            fetchGoingUsers()
        }
    }

    func toggleGoing() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        let venueRef = db.collection("venues").document(venue.id)
            .collection("going").document(uid)

        if isGoing {
            venueRef.delete()
            isGoing = false
            goingUsers.removeAll { $0 == currentUsername }
        } else {
            db.collection("users").document(uid).getDocument { doc, _ in
                let username = doc?.data()?["username"] as? String ?? "Someone"
                currentUsername = username
                venueRef.setData([
                    "username": username,
                    "timestamp": Timestamp(),
                    "date": Calendar.current.startOfDay(for: Date()).timeIntervalSince1970
                ])
                isGoing = true
                goingUsers.append(username)
            }
        }
    }

    func fetchGoingUsers() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let venueId = venue.id
        let db = Firestore.firestore()
        let todayStart = Calendar.current.startOfDay(for: Date()).timeIntervalSince1970

        db.collection("venues").document(venueId)
            .collection("going")
            .whereField("date", isEqualTo: todayStart)
            .getDocuments { snapshot, _ in
                guard let docs = snapshot?.documents else { return }
                goingUsers = docs.compactMap { $0.data()["username"] as? String }
                isGoing = docs.contains { $0.documentID == uid }
                if let myDoc = docs.first(where: { $0.documentID == uid }) {
                    currentUsername = myDoc.data()["username"] as? String ?? ""
                }
            }
    }
}


#Preview {
    NavigationStack {
        VenueDetailView(venue: Venue(
            id: "preview",
            name: "Test Bar",
            city: "Boston",
            neighborhood: "Allston",
            lineStatus: "Short",
            crowdLevel: "Busy",
            coverStatus: "$10",
            entryStatus: "10 min wait",
            lastUpdated: Date(),
            note: "Great DJ!"
        ), store: VenueStore())
    }
}
