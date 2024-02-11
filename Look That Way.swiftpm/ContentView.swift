import SwiftUI

struct ContentView: View {
    @Environment(AppState.self) private var appState
    @State private var canvasImage: UIImage?
    var body: some View {
        HStack {
            FaceOverlay()
                .ignoresSafeArea()
            VStack {
                Canvas(image: $canvasImage)
                    .frame(width: 300, height: 300)
                    .border(Color.black, width: 1)
                Button("Save") {
                    canvasImage = nil // Clear the previous image
                }
            }
            Game()
        }
    }
}

enum FaceDirection: CaseIterable {
    case front
    case up
    case down
    case left
    case right

    var faceImage: Image {
        switch self {
        case .front:
            Image("front")
        case .up:
            Image("up")
        case .down:
            Image("down")
        case .left:
            Image("left")
        case .right:
            Image("right")
        }
    }

    var fingerText: Text {
        switch self {
        case .front:
            Text("🫵")
        case .up:
            Text("👆")
        case .down:
            Text("👇")
        case .left:
            Text("👈")
        case .right:
            Text("👉")
        }
    }

    static func random() -> FaceDirection {
            return FaceDirection.allCases.randomElement()!
    }
}
