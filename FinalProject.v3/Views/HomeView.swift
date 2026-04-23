//
//  HomeView.swift
//  FinalProject.v1
//
//  Created by Nick Collins on 4/17/26.
//

import SwiftUI

struct HomeView: View {
    @State private var store = VenueStore()
    @State private var showAddVenue = false

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {

                // Headline
                Text("Going out?")
                    .font(.largeTitle)
                    .bold()
                    .padding(.horizontal)
                    .padding(.top)

                // Search Bar
                TextField("Search venues...", text: $store.searchText)
                    .textFieldStyle(.roundedBorder)
                    .padding()

                //  Venue List
                List(store.filteredVenues) { venue in
                    NavigationLink(destination: VenueDetailView(venue: venue, store: store)) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(venue.name)
                                .font(.headline)
                            Text(venue.neighborhood)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(.plain)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("Add Venue", systemImage: "plus") {
                        showAddVenue = true
                    }
                }
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
