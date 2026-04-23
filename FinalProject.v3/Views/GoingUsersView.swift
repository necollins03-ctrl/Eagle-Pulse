//
//  GoingUsersView.swift
//  FinalProject.v2
//

import SwiftUI

struct GoingUsersView: View {
    var users: [String]

    var body: some View {
        ZStack {
            Color("blackBC")
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                Text("Going Tonight")
                    .font(.custom("BebasNeue-Regular", size: 36))
                    .foregroundStyle(Color("goldBC"))
                    .padding(.horizontal)
                    .padding(.top)

                Rectangle()
                    .frame(height: 1)
                    .foregroundStyle(Color("goldBC").opacity(0.3))
                    .padding(.horizontal)
                    .padding(.top, 4)

                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(users, id: \.self) { username in
                            HStack(spacing: 12) {
                                Image(systemName: "person.circle.fill")
                                    .foregroundStyle(Color("maroonBC"))
                                    .font(.title3)
                                Text(username)
                                    .foregroundStyle(.white)
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .padding(.vertical, 14)
                            .padding(.horizontal)

                            Rectangle()
                                .frame(height: 1)
                                .foregroundStyle(Color.white.opacity(0.06))
                                .padding(.horizontal)
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    GoingUsersView(users: ["sack_collins", "eaglefan99", "bc_nights"])
}
