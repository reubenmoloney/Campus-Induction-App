//
//  MusicChallenge.swift
//  CampusInduction
//
//  Created by cathair mab on 06/03/2025.
//

import SwiftUI
import AVFoundation

struct MusicGameView: View {
    var onComplete: () -> Void
    
    @State private var sequence: [Int] = []
    @State private var playerSequence: [Int] = []
    @State private var isPlayingSequence = false
    @State private var score = 0
    @State private var squares: [Color] = Array(repeating: .gray, count: 9)
    @State private var audioPlayers: [AVAudioPlayer?] = Array(repeating: nil, count: 9)
    
    let sounds = ["a", "b", "c", "c2", "d", "e", "f", "f2", "g"]
    
    var body: some View {
        VStack {
            Text("Score: \(score)")
                .font(.title)
                .padding()
            
            GridStack(rows: 3, columns: 3, content: { row, col -> AnyView in
                let index = row * 3 + col
                return AnyView(
                    Rectangle()
                        .fill(squares[index])
                        .frame(width: 80, height: 80)
                        .cornerRadius(10)
                        .onTapGesture {
                            if !isPlayingSequence {
                                playTone(index)
                                playerSequence.append(index)
                                checkSequence()
                                
                                squares[index] = .blue
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                    squares[index] = .gray
                                }
                            }
                        }
                )
            })
            .padding()
            
            Button("Start Game") {
                startGame()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .onAppear {
            loadSounds()
        }
    }
    
    func loadSounds() {
        for i in 0..<sounds.count {
            if let url = Bundle.main.url(forResource: sounds[i], withExtension: "wav") {
                audioPlayers[i] = try? AVAudioPlayer(contentsOf: url)
            }
        }
    }
    
    func startGame() {
        sequence.removeAll()
        playerSequence.removeAll()
        score = 0
        addNewStep()
    }
    
    func addNewStep() {
        playerSequence.removeAll()
        sequence.append(Int.random(in: 0..<9))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            playSequence()
        }
    }
    
    func playSequence() {
        isPlayingSequence = true
        for (i, index) in sequence.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(i) * 1.0) {
                playTone(index)
                highlightSquare(index)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + Double(sequence.count) * 1.0) {
            isPlayingSequence = false
        }
    }
    
    func playTone(_ index: Int) {
        if index < audioPlayers.count, let player = audioPlayers[index] {
            player.currentTime = 0
            player.play()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                player.stop()
            }
        }
    }
    
    func highlightSquare(_ index: Int) {
        squares[index] = .yellow
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            squares[index] = .gray
        }
    }
    
    func checkSequence() {
        if playerSequence == Array(sequence.prefix(playerSequence.count)) {
            if playerSequence.count == sequence.count {
                score += 1
                if score >= 5 { // Win Condition
                    onComplete()
                } else {
                    addNewStep()
                }
            }
        } else {
            sequence.removeAll()
            playerSequence.removeAll()
            score = 0
        }
    }
}

struct GridStack<Content: View>: View {
    let rows: Int
    let columns: Int
    let content: (Int, Int) -> Content // This must return a View

    var body: some View {
        VStack {
            ForEach(0..<rows, id: \.self) { row in
                HStack {
                    ForEach(0..<columns, id: \.self) { col in
                        content(row, col)
                    }
                }
            }
        }
    }
}
