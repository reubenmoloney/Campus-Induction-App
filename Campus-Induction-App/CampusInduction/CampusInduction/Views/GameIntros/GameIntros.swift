//
//  GameIntros.swift
//  CampusInduction
//
//  Created by cathair mab on 14/03/2025.
//

import SwiftUI

// MARK: - Library Game Wrapper
struct LibraryGameWithIntro: View {
    var onBadgeEarned: () -> Void
    
    var body: some View {
        AvatarIntroView(
            introText: "📚 Welcome to the Library! Open 24/7, it's an area where students can come to study in silence or book rooms to work on group projects together. Swipe your library card and get a simulated 360° view and earn your Library Explorer badge.",
            startAction: {},
                content: {
                    QuickLibraryEntryGame(onComplete: {
                    onBadgeEarned()
                })
            }
        )
    }
}

struct GridGameWithIntro: View {
    var onBadgeEarned: () -> Void
    
    var body: some View {
        AvatarIntroView(
            introText: "Welcome to the Grid! Featuring the latest technological innovations, including Augmented Reality, Virtual Reality and Gaming studios. Open 7 days a week the Grid provides an innovative teaching and learning environment for mathematics, engineering and computer science!",
            startAction: {},
                content: {
                    ComputingGameView(onComplete: {
                    onBadgeEarned()
                })
            }
        )
    }
}

struct UnionGameWithIntro: View {
    var onBadgeEarned: () -> Void
    
    var body: some View {
        AvatarIntroView(
            introText: "Welcome to the Union! Inside is a cafe, bar and an events venue! With social events happening inside here everyday theres always something going on in the Heriot Watt Union! Try this AR pub quiz to answer university questions and explore the union!",
            startAction: {},
                content: {
                    UnionGameView(onComplete: {
                    onBadgeEarned()
                })
            }
        )
    }
}

struct OriamGameWithIntro: View {
    var onBadgeEarned: () -> Void
    
    var body: some View {
        AvatarIntroView(
            introText: "Welcome to the Oriam! Inside is multiple sports halls, squash kits, a gym and many more available facilities that students can book to play with one another or attend as a society. Run to the AR marker in under 40 seconds to earn the oriam badge!",
            startAction: {},
                content: {
                    OriamGameView(onComplete: {
                    onBadgeEarned()
                })
            }
        )
    }
}

struct MusicGameWithIntro: View {
    var onBadgeEarned: () -> Void
    
    var body: some View {
        AvatarIntroView(
            introText: "Welcome to the Music Cottage! The Music Cottage provides a central hub including several practice rooms and a small rehearsal space which is also used for informal concerts. Get a score of 5 in the music game to unlock your badge!",
            startAction: {},
                content: {
                    MusicGameView(onComplete: {
                    onBadgeEarned()
                })
            }
        )
    }
}
