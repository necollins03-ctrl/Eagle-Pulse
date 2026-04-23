//
//  Venue.swift
//  FinalProject.v2
//
//  Created by Nick Collins on 4/17/26.
//

import Foundation
import FirebaseFirestore


struct Venue: Identifiable, Codable {
    var id: String
    var name: String
    var city: String
    var neighborhood: String
    var lineStatus: String
    var crowdLevel: String
    var coverStatus: String
    var entryStatus: String
    var lastUpdated: Date
    var note: String?
}
