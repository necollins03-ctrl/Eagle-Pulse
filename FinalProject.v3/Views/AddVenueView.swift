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
        ZStack {
            Color("blackBC")
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 28) {

                    // Venue Info
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Venue Info")
                            .font(.custom("BebasNeue-Regular", size: 18))
                            .foregroundStyle(Color("goldBC"))
                            .padding(.horizontal)

                        VStack(spacing: 10) {
                            TextField("Venue name", text: $name)
                                .foregroundStyle(.white)
                                .padding(12)
                                .background(Color.white.opacity(0.07))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color("goldBC").opacity(0.2), lineWidth: 1)
                                )

                            TextField("Neighborhood (e.g. Fenway, Seaport)", text: $neighborhood)
                                .foregroundStyle(.white)
                                .padding(12)
                                .background(Color.white.opacity(0.07))
                                .cornerRadius(10)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color("goldBC").opacity(0.2), lineWidth: 1)
                                )
                        }
                        .padding(.horizontal)
                    }

                    OptionSection(title: "Line", options: lineOptions, selected: $lineStatus)
                    OptionSection(title: "Crowd", options: crowdOptions, selected: $crowdLevel)
                    OptionSection(title: "Cover", options: coverOptions, selected: $coverStatus)
                    OptionSection(title: "Entry", options: entryOptions, selected: $entryStatus)

                    // Note
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Note (optional)")
                            .font(.custom("BebasNeue-Regular", size: 18))
                            .foregroundStyle(Color("goldBC"))
                            .padding(.horizontal)

                        TextField("Add a note...", text: $note)
                            .foregroundStyle(.white)
                            .padding(12)
                            .background(Color.white.opacity(0.07))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("goldBC").opacity(0.2), lineWidth: 1)
                            )
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
        }
        .navigationTitle("Add Venue")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color("blackBC"), for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel", role: .cancel) {
                    dismiss()
                }
                .foregroundStyle(Color("maroonBC"))
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
                .foregroundStyle(Color("goldBC"))
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddVenueView(store: VenueStore())
    }
}
