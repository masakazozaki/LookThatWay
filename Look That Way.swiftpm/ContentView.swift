import SwiftUI

struct ContentView: View {
    var appState: AppState
    @State var isPresentingResultView = false
    @State private var canvasImage: UIImage?
    var body: some View {
        VStack {
            Group {
                FaceOverlay(appState: appState)
                    .ignoresSafeArea()
                Button("Re-Center") {
                    appState.shouldSetInitialFaceAngle = true
                }

                Button("Start") {
                    appState.resetAndStart()
                    SoundManager.shared.playSound(name: "start")
                    SoundManager.shared.playGameBGM()
                }
            }
            appState.userCurrentFaceDirection.faceImage
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
            if let countdown = appState.countdown {
                CountdownGauge(countDown: countdown)
            }
            HStack {
                ForEach(appState.cpuFaceDirections, id: \.self) { direction in
                    direction.faceImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                }

                //                Canvas(image: $canvasImage)
                //                    .frame(width: 300, height: 300)
                //                    .border(Color.black, width: 1)

            }
            Text("\(appState.matchNumber)")
                .font(.largeTitle)
                .bold()
            HStack {
                Text("HP \(appState.userHP)")
                    .font(.headline)
                HPGauge(hp: appState.userHP)
                Spacer()
                Text("Point: \(appState.userPoint)")
                    .font(.headline)
            }
            .padding()
        }
        .onAppear {
            SoundManager.shared.playInitialBGM()
        }
        .onDisappear {
            SoundManager.shared.stopBGM()
        }
        .onChange(of: appState.userHP) {
            if appState.userHP == 0 {
                isPresentingResultView = true
                SoundManager.shared.playInitialBGM()
            }
        }
        .sheet(isPresented: $isPresentingResultView) {
            ResultView(appState: appState)
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
    static func randomExcludingFront() -> FaceDirection {
            let excludingFront = FaceDirection.allCases.filter { $0 != .front }
            return excludingFront.randomElement()!
        }
}
