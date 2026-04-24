//
//  HomeView.swift
//  FinalProject.v1
//
//  Created by Nick Collins on 4/17/26.
//

import SwiftUI
import FirebaseAuth

struct HomeView: View {
    @State private var store = VenueStore()
    @State private var showAddVenue = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color("blackBC")
                    .ignoresSafeArea()
                
                VStack(alignment: .leading, spacing: 0) {

                    // Headline
                    Text("Going out?")
                        .font(.custom("BebasNeue-Regular", size: 42))
                        .foregroundStyle(Color("goldBC"))
                        .padding(.horizontal)
                        .padding(.top)

                    // Search Bar
                    ZStack(alignment: .leading) {
                        if store.searchText.isEmpty {
                            Text("Search venues...")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundStyle(Color.white.opacity(0.3))
                                .padding(.leading, 4)
                        }
                        TextField("", text: $store.searchText)
                            .foregroundStyle(.white)
                            .tint(Color("goldBC"))
                    }
                    .padding(10)
                    .background(Color.white.opacity(0.08))
                    .cornerRadius(10)
                    .padding()
                    
                    // Venue List
                    NavigationStack {
                        List(store.filteredVenues) { venue in
                            NavigationLink(destination: VenueDetailView(venue: venue, store: store)) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(venue.name)
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                    Text(venue.neighborhood)
                                        .font(.subheadline)
                                        .foregroundStyle(Color("goldBC").opacity(0.7))
                                }
                                .padding(.vertical, 6)
                            }
                            .listRowBackground(Color.white.opacity(0.05))
                        }
                        .listStyle(.plain)
                        .listRowSeparatorTint(Color("goldBC").opacity(0.8))
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color("blackBC"), for: .navigationBar)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: { showAddVenue = true }) {
                        Image(systemName: "plus")
                            .foregroundStyle(Color("goldBC"))
                    }
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        do {
                            try Auth.auth().signOut()
                        } catch {
                            print("Sign out error: \(error)")
                        }
                    }) {
                        Image(systemName: "person.circle")
                            .foregroundStyle(Color("goldBC"))
                    }                }
            }
            .sheet(isPresented: $showAddVenue) {
                NavigationStack {
                    AddVenueView(store: store)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
