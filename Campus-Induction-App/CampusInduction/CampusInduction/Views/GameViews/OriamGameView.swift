//
//  ARChallengeView.swift
//  CampusInduction
//
//  Created by cathair mab on 21/02/2025.
//

import os
import SwiftUI
import ARKit
import ARKit_CoreLocation
import RealityKit

struct OriamGameView: View {
    @State private var arView: ARView?
    @State private var timerValue = 40
    @State private var gameOver = false
    @State private var success = false
    @State private var distanceToTarget: Float = 100.0
    let targetPosition = SIMD3<Float>(0, 0, -20) // distance infront meters in front

    var onComplete: () -> Void

    var body: some View {
        ZStack {
            ARSprintARView(arView: $arView, targetPosition: targetPosition, distanceToTarget: $distanceToTarget)
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Text("⏱ Time Left: \(timerValue)s")
                    .font(.headline)
                    .padding(8)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(8)

                Text(String(format: "📏 Distance: %.2f m", distanceToTarget))
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Color.black.opacity(0.6))
                    .cornerRadius(8)

                if gameOver {
                    Text(success ? "🎉 You reached the goal!" : "❌ Time's up! Try again.")
                        .font(.title2)
                        .padding()
                        .background(success ? Color.green.opacity(0.7) : Color.red.opacity(0.7))
                        .cornerRadius(10)

                    if success {
                        Button("Finish") {
                            onComplete()
                        }
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .onAppear {
            startTimer()
        }
    }

    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if timerValue > 0 {
                timerValue -= 1
                if distanceToTarget < 1.0 {
                    success = true
                    gameOver = true
                    timer.invalidate()
                }
            } else {
                gameOver = true
                timer.invalidate()
            }
        }
    }
}

struct ARSprintARView: UIViewRepresentable {
    @Binding var arView: ARView?
    let targetPosition: SIMD3<Float>
    @Binding var distanceToTarget: Float

    func makeUIView(context: Context) -> ARView {
        let view = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        view.session.run(config)

        // Add target anchor and entity
        let anchor = AnchorEntity(world: targetPosition)
        let coneMesh = MeshResource.generateCone(height: 1.2, radius: 0.6)
        let target = ModelEntity(mesh: coneMesh, materials: [SimpleMaterial(color: .cyan, isMetallic: true)])
        target.transform.rotation = simd_quatf(angle: .pi, axis: [1, 0, 0])
        target.position = [0, 0.1, 0]
        anchor.addChild(target)
        view.scene.addAnchor(anchor)

        // Save reference
        self.arView = view

        // Start distance update loop
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
            if let camTransform = view.session.currentFrame?.camera.transform {
                let camPosition = SIMD3<Float>(camTransform.columns.3.x, camTransform.columns.3.y, camTransform.columns.3.z)
                distanceToTarget = distance(camPosition, targetPosition)
            }
        }

        return view
    }

    func updateUIView(_ uiView: ARView, context: Context) {}
}
