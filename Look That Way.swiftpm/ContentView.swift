import SwiftUI

struct ContentView: View {
    var body: some View {
        FaceOverlay()
            .ignoresSafeArea()
    }
}

enum FaceDirection {
    case up
    case down
    case left
    case right
}
