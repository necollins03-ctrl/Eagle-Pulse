//
//  OptionSection.swift
//  FinalProject.v2
//
//  Created by Nick Collins on 4/22/26.
//

import SwiftUI

struct OptionSection: View {
    var title: String
    var options: [String]
    @Binding var selected: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.custom("BebasNeue-Regular", size: 18))
                .foregroundStyle(Color("goldBC"))
                .padding(.horizontal)

            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                ForEach(options, id: \.self) { option in
                    Button(action: { selected = option }) {
                        Text(option)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(selected == option ? Color("goldBC") : .white.opacity(0.6))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(selected == option ? Color("maroonBC") : Color.white.opacity(0.07))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(selected == option ? Color("goldBC").opacity(0.4) : Color.white.opacity(0.1), lineWidth: 1)
                            )
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

#Preview {
    OptionSection(title: "Line", options: ["None", "Short", "Moderate", "Long"], selected: .constant("Short"))
}
