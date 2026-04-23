//
//  VenueStore.swift
//  FinalProject.v2
//
//  Created by Nick Collins on 4/17/26.
//

import Foundation
import Observation
import FirebaseFirestore

@Observable
class VenueStore {
    var venues: [Venue] = []
    var searchText: String = ""
    
    private let db = Firestore.firestore()
    
    init() {
        fetchVenues()
    }

    // Filtered Search
    var filteredVenues: [Venue] {
        if searchText.isEmpty {
            return venues
        } else {
            return venues.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        }
    }

    // Fetch all venues from Firestore (live listener)
    func fetchVenues() {
        db.collection("venues").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            self.venues = documents.compactMap { doc in
                try? doc.data(as: Venue.self)
            }
        }
    }

    // Confirm (updates timestamp only)
    func confirmVenue(venue: Venue) {
        db.collection("venues").document(venue.id).updateData([
            "lastUpdated": Date()
        ])
    }

    // Update (writes new status values)
    func updateVenue(venue: Venue) {
        try? db.collection("venues").document(venue.id).setData(from: venue)
    }

    // Add new venue
    func addVenue(venue: Venue) {
        try? db.collection("venues").document(venue.id).setData(from: venue)
    }
}
