//
//  ReceptionChallenge.swift
//  CampusInduction
//
//  Created by cathair mab on 28/03/2025.
//

import SwiftUI

struct TutorialGameView: View {
    @Environment(\.dismiss) var dismiss
    @State private var dialogueStage = 0
    var onComplete: () -> Void

    let dialogues: [String] = [
        "👋 Hi there! I’m your Campus Guide.",
        "🗺️ This app will help you explore your new surroundings with fun location-based games.",
        "📍 See those pins on the map? Those are waypoints — head to them to unlock games and challenges!",
        "🎮 Ready to get started? Your first real challenge is waiting at the Library."
    ]

    let spriteImages: [String] = [
        "GuideSprite_Wave",
        "GuideSprite_Map",
        "GuideSprite_Point",
        "GuideSprite_Excited"
    ]

    var body: some View {
        VStack(spacing: 20) {
            Spacer()

            // Dynamic guide sprite pose
            Image(spriteImages[dialogueStage])
                .resizable()
                .scaledToFit()
                .frame(height: 200)

            // Speech bubble
            Text(dialogues[dialogueStage])
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
                .font(.body)
                .multilineTextAlignment(.center)
                .transition(.opacity)
                .animation(.easeInOut, value: dialogueStage)

            Spacer()

            Button(action: advanceDialogue) {
                Text(dialogueStage < dialogues.count - 1 ? "Next" : "Start Journey")
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
    }

    func advanceDialogue() {
        if dialogueStage < dialogues.count - 1 {
            dialogueStage += 1
        } else {
            onComplete() // 🎯 Unlock badge via parent view
            dismiss()
        }
    }
}
