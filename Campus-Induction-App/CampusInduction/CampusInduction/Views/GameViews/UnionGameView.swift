//
//  QuizChallenge.swift
//  CampusInduction
//
//  Created by cathair mab on 06/03/2025.
//

import SwiftUI
import ARKit
import RealityKit


struct UnionGameView: View {
    @State private var currentQuestionIndex = 0
    @State private var score = 0
    @State private var showResult = false
    @State private var arView: ARView?

    var onComplete: () -> Void

    let questions: [(question: String, options: [String], correctAnswer: Int)] = [
        ("What year was the university founded?", ["1821", "1905", "1967", "2001"], 0),
        ("Which building is the Student Union located in?", ["Main Hall", "Library", "Student Center", "Sports Hall"], 2),
        ("How many students are enrolled?", ["10,000", "25,000", "40,000", "50,000"], 1)
    ]

    var body: some View {
        ZStack {
            ARViewContainer(arView: $arView, question: showResult ? "" : questions[currentQuestionIndex].question)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Text("AR Quiz Hunt")
                    .font(.largeTitle)
                    .padding()
                    .background(Color.black.opacity(0.5))
                    .cornerRadius(10)

                if !showResult {
                    VStack(spacing: 10) {
                        ForEach(0..<questions[currentQuestionIndex].options.count, id: \.self) { index in
                            Button(action: {
                                checkAnswer(index)
                            }) {
                                Text(questions[currentQuestionIndex].options[index])
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.blue.opacity(0.8))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .padding()
                } else {
                    Text("Quiz Completed! 🎉")
                        .font(.title)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)

                    Text("Final Score: \(score) / \(questions.count)")
                        .font(.headline)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .cornerRadius(10)

                    Button("Finish Quiz") {
                        onComplete()
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
        }
    }

    func checkAnswer(_ selectedIndex: Int) {
        if selectedIndex == questions[currentQuestionIndex].correctAnswer {
            score += 1
        }

        if currentQuestionIndex < questions.count - 1 {
            currentQuestionIndex += 1
        } else {
            showResult = true
        }
    }
}

struct ARViewContainer: UIViewRepresentable {
    @Binding var arView: ARView?
    var question: String

    func makeUIView(context: Context) -> ARView {
        let view = ARView(frame: .zero)
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = [.horizontal]
        view.session.run(config)

        self.arView = view
        if !question.isEmpty {
            addQuizQuestion(to: view, text: question)
        }
        return view
    }

    func updateUIView(_ uiView: ARView, context: Context) {
        uiView.scene.anchors.removeAll()
        if !question.isEmpty {
            addQuizQuestion(to: uiView, text: question)
        }
    }

    func addQuizQuestion(to view: ARView, text: String) {
        let anchor = AnchorEntity(plane: .horizontal)
        let textMesh = MeshResource.generateText(
            text,
            extrusionDepth: 0.02,
            font: .systemFont(ofSize: 0.5),
            containerFrame: .zero,
            alignment: .center,
            lineBreakMode: .byWordWrapping
        )
        let textMaterial = SimpleMaterial(color: .blue, isMetallic: false)
        let textEntity = ModelEntity(mesh: textMesh, materials: [textMaterial])
        textEntity.position = [0, 0.9, 0.3]
        anchor.addChild(textEntity)
        view.scene.addAnchor(anchor)
    }
}

