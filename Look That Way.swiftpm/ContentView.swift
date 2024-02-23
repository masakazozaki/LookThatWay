import SwiftUI

struct ContentView: View {
    var appState: AppState
    @State var isPresentingResultView = false
    @State private var canvasImage: UIImage?
    @State private var tmpHighlighted = false
    var body: some View {
        VStack {
            Group {
                ZStack {
                    HStack {
                        Spacer()
                        FaceOverlay(appState: appState)
                            .aspectRatio(1, contentMode: .fit)
                            .ignoresSafeArea()
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Button {
                            appState.shouldSetInitialFaceAngle = true
                        } label: {
                            Text("Re-Center")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.cyan)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                        }
                    }
                }

            }
            appState.userCurrentFaceDirection.faceImage
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
//            FaceView(faceDirection: appState.userCurrentFaceDirection, isHighlighted: $tmpHighlighted)
            if let countdown = appState.countdown {
                CountdownGauge(countDown: countdown)
            }
            HStack {
                ForEach(appState.cpuFaceDirections, id: \.self) { direction in
//                    FaceView(faceDirection: direction, isHighlighted: $tmpHighlighted)
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
            ZStack {
                HStack {
                    Text("HP \(appState.userHP)")
                        .font(.headline)
                    HPGauge(hp: appState.userHP)
                    Spacer()
                    Text("Point: \(appState.userPoint)")
                        .font(.headline)
                }
                .padding()
                Button {
                    appState.resetAndStart()
                    SoundManager.shared.playSound(name: "start")
                    SoundManager.shared.playGameBGM()
                } label : {
                    Text("Start")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .padding()
                        .background(.green)
                        .clipShape(RoundedRectangle(cornerRadius: 24))
                }
            }

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
