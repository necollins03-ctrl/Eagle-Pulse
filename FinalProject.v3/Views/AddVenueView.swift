//
//  AddVenueView.swift
//  FinalProject.v1
//
//  Created by Nick Collins on 4/17/26.
//

import SwiftUI

struct AddVenueView: View {
    var store: VenueStore
    @Environment(\.dismiss) var dismiss

    @State private var name = ""
    @State private var neighborhood = ""
    @State private var lineStatus = "None"
    @State private var crowdLevel = "Moderate"
    @State private var coverStatus = "No cover"
    @State private var entryStatus = "Walk in"
    @State private var note = ""

    let lineOptions = ["None", "Short", "Moderate", "Long"]
    let crowdOptions = ["Empty", "Chill", "Moderate", "Busy", "Packed"]
    let coverOptions = ["No cover", "$5", "$10", "$15", "$20+"]
    let entryOptions = ["Walk in", "5 min wait", "10 min wait", "20 min wait", "30+ min wait"]

    var body: some View {
        Form {
            Section("Venue Info") {
                TextField("Venue name", text: $name)
                TextField("Neighborhood (e.g. Fenway, Seaport)", text: $neighborhood)
            }

            Section("Line") {
                Picker("Line Status", selection: $lineStatus) {
                    ForEach(lineOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Crowd") {
                Picker("Crowd Level", selection: $crowdLevel) {
                    ForEach(crowdOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.wheel)
            }

            Section("Cover") {
                Picker("Cover Status", selection: $coverStatus) {
                    ForEach(coverOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.segmented)
            }

            Section("Entry") {
                Picker("Entry Status", selection: $entryStatus) {
                    ForEach(entryOptions, id: \.self) { option in
                        Text(option).tag(option)
                    }
                }
                .pickerStyle(.wheel)
            }

            Section("Note (optional)") {
                TextField("Add a note...", text: $note)
            }
        }
        .navigationTitle("Add Venue")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Add") {
                    let newVenue = Venue(
                        id: UUID().uuidString,
                        name: name,
                        city: "Boston",
                        neighborhood: neighborhood,
                        lineStatus: lineStatus,
                        crowdLevel: crowdLevel,
                        coverStatus: coverStatus,
                        entryStatus: entryStatus,
                        lastUpdated: Date(),
                        note: note.isEmpty ? nil : note
                    )
                    store.addVenue(venue: newVenue)
                    dismiss()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddVenueView(store: VenueStore())
    }
}
