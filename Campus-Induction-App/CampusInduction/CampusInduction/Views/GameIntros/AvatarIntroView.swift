//
//  AvatarIntroDefault.swift
//  CampusInduction
//
//  Created by cathair mab on 14/03/2025.
//

import SwiftUI

struct AvatarIntroView<Content: View>: View {
    let introText: String
    let startAction: () -> Void
    let content: () -> Content

    @State private var showGame = false
    @State private var selectedSpriteImage: String = "GuideSprite_Wave" // default
    
    let spriteOptions = ["GuideSprite_Wave", "GuideSprite_Map","GuideSprite_Point","GuideSprite_Excited"]

    var body: some View {
        VStack(spacing: 24) {
            if !showGame {
                VStack(spacing: 16) {
                    // Avatar Character Image
                    Image(selectedSpriteImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)

                    // Speech Bubble / Intro Text
                    Text(introText)
                        .font(.system(size: 18, weight: .medium))
                        .multilineTextAlignment(.center)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color(.systemGray6))
                                .shadow(radius: 3)
                        )
                        .padding(.horizontal)

                    // Start Game Button
                    Button(action: {
                        showGame = true
                        startAction()
                    }) {
                        Text("Start Challenge")
                            .font(.headline)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .padding(.horizontal)
                    }
                }
                .onAppear {
                    // Pick a random sprite image when the view appears
                    selectedSpriteImage = spriteOptions.randomElement() ?? "GuideSprite_Wave"
                }
            } else {
                content()
            }
        }
        .padding()
    }
}
