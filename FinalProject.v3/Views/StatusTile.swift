//
//  StatusTile.swift
//  FinalProject.v2
//
//  Created by Nick Collins on 4/23/26.
//

import SwiftUI

struct StatusTile: View {
    var label: String
    var value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(label)
                .font(.caption)
                .foregroundStyle(Color("goldBC").opacity(0.7))
            Text(value)
                .font(.headline)
                .bold()
                .foregroundStyle(.white)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.white.opacity(0.07))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color("goldBC").opacity(0.2), lineWidth: 1)
        )
    }
}

#Preview {
    StatusTile(label: "Line", value: "Short")
}
