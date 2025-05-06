//
//  CodingChallenge.swift
//  CampusInduction
//
//  Created by cathair mab on 06/03/2025.
//

import SwiftUI

struct ComputingGameView: View {
    @State private var codeBlocks = [
        "print(\"Hello, World!\")",
        "func main() {",
        "}",
        "main()"
    ].shuffled()
    
    @State private var userOrder: [String] = []
    @State private var isCorrect = false
    @State private var showResult = false
    
    var onComplete: () -> Void
    
    let correctOrder = [
        "func main() {",
        "print(\"Hello, World!\")",
        "}",
        "main()"
    ]
    
    var body: some View {
        VStack {
            Text("Arrange the code blocks in the correct order to print \"Hello, World!\"")
                .font(.headline)
                .padding()
            
            VStack {
                ForEach(codeBlocks, id: \..self) { block in
                    Text(block)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.2))
                        .cornerRadius(8)
                        .onDrag { NSItemProvider(object: block as NSString) }
                        .onDrop(of: ["public.text"], delegate: DropViewDelegate(item: block, items: $codeBlocks))
                }
            }
            .padding()
            
            Button("Check Answer") {
                isCorrect = codeBlocks == correctOrder
                showResult = true
                if isCorrect {
                    onComplete()
                }
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(8)
            
            if showResult {
                Text(isCorrect ? "✅ Correct! Great job!" : "❌ Try again!")
                    .font(.title)
                    .foregroundColor(isCorrect ? .green : .red)
                    .padding()
            }
        }
        .padding()
    }
}

struct DropViewDelegate: DropDelegate {
    let item: String
    @Binding var items: [String]
    
    func performDrop(info: DropInfo) -> Bool {
        guard let sourceItem = info.itemProviders(for: ["public.text"]).first else { return false }
        sourceItem.loadObject(ofClass: NSString.self) { (object, error) in
            DispatchQueue.main.async {
                if let str = object as? String, let fromIndex = items.firstIndex(of: str), let toIndex = items.firstIndex(of: item) {
                    items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
                }
            }
        }
        return true
    }
}
