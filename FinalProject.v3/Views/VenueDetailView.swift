//
//  VenueDetailView.swift
//  FinalProject.v1
//
//  Created by Nick Collins on 4/17/26.
//

import SwiftUI

struct VenueDetailView: View {
    var venue: Venue
    var store: VenueStore
    @State private var showUpdateView = false

    var hasEntryForToday: Bool {
        Calendar.current.isDateInToday(venue.lastUpdated)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {

                // Header
                VStack(alignment: .leading, spacing: 4) {
                    Text(venue.name)
                        .font(.largeTitle)
                        .bold()
                    Text(venue.neighborhood)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal)

                // Four Status Tiles or No Entry Message
                if hasEntryForToday {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatusTile(label: "Line", value: venue.lineStatus)
                        StatusTile(label: "Crowd", value: venue.crowdLevel)
                        StatusTile(label: "Cover", value: venue.coverStatus)
                        StatusTile(label: "Entry", value: venue.entryStatus)
                    }
                    .padding(.horizontal)

                    // Last Updated
                    Text("Updated \(venue.lastUpdated.formatted(.relative(presentation: .named)))")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal)

                    // Note (if exists)
                    if let note = venue.note, !note.isEmpty {
                        Text("📝 \(note)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal)
                    }

                } else {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        StatusTile(label: "Line", value: "—")
                        StatusTile(label: "Crowd", value: "—")
                        StatusTile(label: "Cover", value: "—")
                        StatusTile(label: "Entry", value: "—")
                    }
                    .padding(.horizontal)

                    Text("No entries for tonight yet.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary) //TODO: PROBS CHANGE FOR UI PURPOSES
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.top, 4)
                }

                Spacer()

                // Confirm and Update Buttons
                HStack(spacing: 16) {
                    Button {
                        store.confirmVenue(venue: venue)
                    } label: {
                        Text("Confirm")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)

                    Button {
                        showUpdateView = true
                    } label: {
                        Text("Update")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            .padding(.top)
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showUpdateView) {
            NavigationStack {
                UpdateView(venue: venue, store: store)
            }
        }
    }
}

// MARK: - Status Tile Component
struct StatusTile: View {
    var label: String
    var value: String

    var body: some View {
        VStack(spacing: 8) {
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
            Text(value)
                .font(.headline)
                .bold()
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        VenueDetailView(venue: Venue(
            id: "preview",
            name: "Test Bar",
            city: "Boston",
            neighborhood: "Fenway",
            lineStatus: "Short",
            crowdLevel: "Busy",
            coverStatus: "$10",
            entryStatus: "10 min wait",
            lastUpdated: Date(),
            note: nil
        ), store: VenueStore())
    }
}
