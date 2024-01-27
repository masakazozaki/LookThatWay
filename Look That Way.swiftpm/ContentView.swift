import SwiftUI

struct ContentView: View {
    @State private var canvasImage: UIImage?
    var body: some View {
        //        FaceOverlay()
        //            .ignoresSafeArea()
        Canvas(image: $canvasImage)
            .frame(width: 300, height: 300)
            .border(Color.black, width: 1)
        Button("Save") {
            canvasImage = nil // Clear the previous image
        }
    }
}

enum FaceDirection {
    case up
    case down
    case left
    case right
}
