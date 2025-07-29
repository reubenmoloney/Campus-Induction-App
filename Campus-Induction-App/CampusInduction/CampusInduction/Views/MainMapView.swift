//
//  MainMapView.swift
//  CampusInduction
//
//  Created by cathair mab on 12/02/2025.
//

import SwiftUI
import MapKit
import CoreLocation

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

//badge menu view
private var badgeMenu: some View {
    VStack(alignment: .leading) {
        HStack {
            Spacer()
            Button(action: { showMenu.toggle() }) {
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding()
                    .foregroundColor(.white)
            }
        }

        Text("🏅 Your Badges")
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal)

        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 3), spacing: 16) {
                ForEach(allPossibleBadges, id: \.self) { badge in
                    VStack {
                        Image(systemName: badges.contains(badge) ? "seal.fill" : "lock.fill")
                            .resizable()
                            .frame(width: 50, height: badges.contains(badge) ? 50 : 70)
                            .foregroundColor(badges.contains(badge) ? .yellow : .gray)
                    }
                }
            }
            .padding()
        }

        if badges.count >= totalBadgeCount {
            VStack(spacing: 10) {
                Text("🏆 All Badges Collected!")
                    .font(.title3)
                    .foregroundColor(.white)

                Image(systemName: "rosette")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(.green)
            }
            .padding(.bottom)
        }

        Spacer()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
    .background(Color(.darkGray).opacity(0.95))
    .cornerRadius(16)
    .shadow(radius: 10)
    .padding()
    .transition(.move(edge: .leading))
    .animation(.easeInOut, value: showMenu)
}

// badge icon view for the badge menu
struct BadgeIconView: View {
    let badge: String
    let isUnlocked: Bool

    var body: some View {
        Image(systemName: isUnlocked ? "seal.fill" : "lock.fill")
            .resizable()
            .frame(width: 50, height: isUnlocked ? 50 : 70)
            .foregroundColor(isUnlocked ? .yellow : .gray)
    }
}


//game view
@ViewBuilder
private func gameView(for waypoint: BuildingAnnotation) -> some View {
    switch waypoint.title {
    case "Reception":
        TutorialGameView(onComplete: {
            unlockBadge(name: "Welcome Explorer")
            showingGame = false
        })
    case "Library":
        LibraryGameWithIntro(onBadgeEarned: {
            unlockBadge(name: "Library Legend")
            showingGame = false
        })
    case "Student Union":
        UnionGameWithIntro(onBadgeEarned: {
            unlockBadge(name: "Union Achiever")
            showingGame = false
        })
    case "Oriam":
        OriamGameWithIntro(onBadgeEarned: {
            unlockBadge(name: "Oriam Athlete")
            showingGame = false
        })
    case "The Grid":
        GridGameWithIntro(onBadgeEarned: {
            unlockBadge(name: "Code Master")
            showingGame = false
        })
    case "Music Cottage":
        MusicGameWithIntro(onBadgeEarned: {
            unlockBadge(name: "Melody Maestro")
            showingGame = false
        })
    default:
        VStack {
            Text("No game assigned to this location.")
            Button("Close") { showingGame = false }
        }
        .padding()
    }
}




struct MainMapView: View {
    @StateObject private var locationTrackingManager = LocationTrackingManager()
    @State private var showingGame = false
    @State private var currentWaypoint: BuildingAnnotation?

    //bool that detemins weather menu is showing or not
    @State private var showMenu = false
    //this is the toggle button for the menu
    private func burgerMenuButton() -> some View {
    Button(action: {
        showMenu.toggle()
    }) {
        Image(systemName: "line.3.horizontal")
            .resizable()
            .foregroundColor(.white)
            .frame(width: 40, height: 28)
            .padding()
    }
    }

    @State private var badges: [String] = []
    @State private var showRewardPopup = false
    @State private var newBadgeName = ""
    @State private var completedWaypoints: Set<String> = []
    
    @State private var showIntro = true

    let totalBadgeCount = 6
    let allPossibleBadges = [
        "Welcome Explorer",
        "Library Legend",
        "Union Achiever",
        "Oriam Athlete",
        "Code Master",
        "Melody Maestro"
    ]

    var body: some View {
        ZStack {
            // Map
            TiltedMapViewWithMarkers(
                region: $locationTrackingManager.region,
                userLocation: $locationTrackingManager.userLocation,
                buildingAnnotations: WaypointManager.waypoints
            )
            .edgesIgnoringSafeArea(.all)
            
            if showIntro {
                AvatarIntroView(
                    introText: "👋 Welcome! Make your way to main reception to start your induction.",
                    startAction: {
                        showIntro = false
                    },
                    content: {
                        EmptyView()
                    }
                )
            }

            // 🍔 Burger Button Overlay
            VStack {
                HStack {
                    burgerMenuButton()
                    Spacer()
                }
                Spacer()
            }

            // 🏅 Badge Menu
            if showMenu {
                badgeMenu
            }

            // 🎉 Reward Popup
            if showRewardPopup {
                BadgeRewardPopup(badgeName: newBadgeName) {
                    showRewardPopup = false
                }
            }
        }

        // 📍 Location-based game triggering
        .onChange(of: locationTrackingManager.userLocation) { newLocation in
            if let location = newLocation,
               let waypoint = WaypointManager.checkForNearbyWaypoint(userLocation: location),
               !completedWaypoints.contains(waypoint.title) {

                currentWaypoint = waypoint
                showingGame = true
                completedWaypoints.insert(waypoint.title)
            }
        }

        // 🎮 Game View Sheet
        .sheet(isPresented: $showingGame) {
            if let waypoint = currentWaypoint {
                gameView(for: waypoint)
            }
        }

    }

    func unlockBadge(name: String) {
        if !badges.contains(name) {
            badges.append(name)
            newBadgeName = name
            showRewardPopup = true
        }
    }
}
