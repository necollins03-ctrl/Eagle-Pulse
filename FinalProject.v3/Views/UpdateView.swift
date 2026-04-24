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

                    OptionSection(title: "Line", options: lineOptions, selected: $venue.lineStatus)
                    OptionSection(title: "Crowd", options: crowdOptions, selected: $venue.crowdLevel)
                    OptionSection(title: "Cover", options: coverOptions, selected: $venue.coverStatus)
                    OptionSection(title: "Entry", options: entryOptions, selected: $venue.entryStatus)

                    // Note
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Note (optional)")
                            .font(.custom("BebasNeue-Regular", size: 18))
                            .foregroundStyle(Color("goldBC"))

                        TextField("Add a note...", text: Binding(
                            get: { "" },
                            set: { venue.note = $0.isEmpty ? nil : $0 }
                        ))
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
                .padding(.vertical)
            }
        }
        .navigationTitle("Update \(venue.name)")
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
                Button("Submit") {
                    venue.lastUpdated = Date()
                    store.updateVenue(venue: venue)
                    dismiss()
                }
                .foregroundStyle(Color("goldBC"))
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
