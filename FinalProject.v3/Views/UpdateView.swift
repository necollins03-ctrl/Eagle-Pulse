//
//  UpdateView.swift
//  FinalProject.v1
//
//  Created by Nick Collins on 4/17/26.
//

import SwiftUI

struct UpdateView: View {
    @State var venue: Venue
    var store: VenueStore
    @Environment(\.dismiss) var dismiss

    // Picker options
    let lineOptions = ["None", "Short", "Moderate", "Long"]
    let crowdOptions = ["Empty", "Chill", "Moderate", "Busy", "Packed"]
    let coverOptions = ["No cover", "$5", "$10", "$15", "$20+"]
    let entryOptions = ["Walk in", "5 min wait", "10 min wait", "20 min wait", "30+ min wait"]

    var body: some View {
        Form {
            Section("Line") {
                Picker("Line Status", selection: $venue.lineStatus) {
                    ForEach(lineOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Crowd") {
                Picker("Crowd Level", selection: $venue.crowdLevel) {
                    ForEach(crowdOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.wheel)
            }

            Section("Cover") {
                Picker("Cover Status", selection: $venue.coverStatus) {
                    ForEach(coverOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Entry") {
                Picker("Entry Status", selection: $venue.entryStatus) {
                    ForEach(entryOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.wheel)
            }

            Section("Note (optional)") {
                TextField("Add a note...", text: Binding(
                    get: { venue.note ?? "" },
                    set: { venue.note = $0.isEmpty ? nil : $0 }
                ))
            }
        }
        .navigationTitle("Update \(venue.name)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Submit") {
                    venue.lastUpdated = Date()
                    store.updateVenue(venue: venue)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        UpdateView(venue: Venue(
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
