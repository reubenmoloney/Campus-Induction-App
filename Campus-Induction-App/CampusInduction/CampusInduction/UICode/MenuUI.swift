//
//  BurgerMenu.swift
//  CampusInduction
//
//  Created by cathair mab on 01/03/2025.
//

import SwiftUI

struct BurgerMenuView: View {
    @Binding var isMenuOpen: Bool
    var collectedBadges: [String]

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                Button(action: {
                    isMenuOpen.toggle()
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding()
                }
            }

            Text("🏅 Your Badges")
                .font(.headline)
                .padding(.horizontal)

            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(collectedBadges, id: \ .self) { badge in
                        HStack {
                            Image(systemName: "seal.fill")
                            Text(badge)
                        }
                        .padding(.horizontal)
                    }
                }
            }
            Spacer()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white.opacity(0.95))
        .cornerRadius(16)
        .shadow(radius: 10)
        .padding()
    }
}
