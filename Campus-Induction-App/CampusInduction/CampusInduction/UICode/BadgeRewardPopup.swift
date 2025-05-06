//
//  BadgeRewardPopup.swift
//  CampusInduction
//
//  Created by cathair mab on 03/03/2025.
//

import SwiftUI

struct BadgeRewardPopup: View {
    var badgeName: String
    var onDismiss: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.6)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 16) {
                Text("🎉 New Badge Unlocked!")
                    .font(.title2)
                    .foregroundColor(.white)

                Image(systemName: "seal.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.yellow)

                Text(badgeName)
                    .font(.headline)
                    .foregroundColor(.white)

                Button(action: onDismiss) {
                    Text("Awesome!")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(20)
            .shadow(radius: 10)
            .padding(40)
        }
    }
}
