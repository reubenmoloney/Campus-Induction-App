//
//  LibraryAR.swift
//  CampusInduction
//
//  Created by cathair mab on 04/03/2025.
//

import SwiftUI
import SceneKit

struct Library360Viewer: View {
    var body: some View {
        SceneKit360View()
            .edgesIgnoringSafeArea(.all)
    }
}

struct SceneKit360View: UIViewRepresentable {
    
    class Coordinator: NSObject {
        var lastPanLocation = CGPoint.zero
        var cameraOrbit: SCNNode!
        
        @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
            let translation = gesture.translation(in: gesture.view)
            
            let newX = Float(translation.x) * 0.005
            let newY = Float(translation.y) * 0.005
            
            // Rotate the orbit node (horizontal pan = y-axis rotation, vertical pan = x-axis)
            cameraOrbit.eulerAngles.y -= newX
            cameraOrbit.eulerAngles.x -= newY
            
            // Clamp vertical rotation to avoid flipping
            cameraOrbit.eulerAngles.x = max(min(cameraOrbit.eulerAngles.x, .pi / 2), -.pi / 2)
            
            gesture.setTranslation(.zero, in: gesture.view)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        let scene = SCNScene()
        
        // Sphere
        let sphere = SCNSphere(radius: 10)
        sphere.firstMaterial?.isDoubleSided = true
        sphere.firstMaterial?.diffuse.contents = UIImage(named: "library_360")
        let sphereNode = SCNNode(geometry: sphere)
        sphereNode.eulerAngles = SCNVector3(0, Float.pi, 0) // Adjust image starting direction
        scene.rootNode.addChildNode(sphereNode)
        
        // Camera orbit node at center
        let cameraOrbit = SCNNode()
        cameraOrbit.position = SCNVector3Zero
        scene.rootNode.addChildNode(cameraOrbit)
        context.coordinator.cameraOrbit = cameraOrbit
        
        // Camera at center
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(0, 0, 0)
        cameraOrbit.addChildNode(cameraNode)
        
        // Scene setup
        scnView.scene = scene
        scnView.pointOfView = cameraNode
        scnView.allowsCameraControl = false // manual control instead
        scnView.backgroundColor = .black
        
        // Add gesture recognizer
        let panGesture = UIPanGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handlePan(_:)))
        scnView.addGestureRecognizer(panGesture)
        
        return scnView
    }
    
    func updateUIView(_ uiView: SCNView, context: Context) {}
}

struct QuickLibraryEntryGame: View {
    var onComplete: (() -> Void)? = nil

    @State private var showLibraryViewer = false
    @State private var cardSwiped = false
    @State private var dragOffset: CGSize = .zero

    var body: some View {
        VStack {
            if showLibraryViewer {
                VStack {
                    Library360Viewer()

                    Button("🚪 Exit Library View") {
                        showLibraryViewer = false
                        onComplete?()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                }
                .transition(.slide)
            } else {
                if !cardSwiped {
                    Text("🎓 Welcome to the Library")
                        .font(.title)
                        .padding(.bottom, 20)

                    Text("📚 Slide your library card to enter")
                        .font(.headline)

                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray.opacity(0.3))
                            .frame(height: 60)
                            .overlay(Text("⬅️ Slide to Swipe").foregroundColor(.gray))

                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.blue)
                            .frame(width: 150, height: 60)
                            .overlay(Text("💳 Card").foregroundColor(.white))
                            .offset(x: dragOffset.width)
                            .gesture(
                                DragGesture()
                                    .onChanged { gesture in
                                        // Limit movement to the right only
                                        if gesture.translation.width > 0 {
                                            dragOffset = gesture.translation
                                        }
                                    }
                                    .onEnded { gesture in
                                        if gesture.translation.width > 120 {
                                            // Considered a successful swipe
                                            withAnimation {
                                                cardSwiped = true
                                                showLibraryViewer = true
                                            }
                                        } else {
                                            // Not far enough — snap back
                                            withAnimation {
                                                dragOffset = .zero
                                            }
                                        }
                                    }
                            )
                    }
                    .padding()
                }
            }
        }
        .padding()
    }
}
