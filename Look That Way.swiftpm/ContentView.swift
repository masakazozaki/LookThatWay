import SwiftUI

struct ContentView: View {
    var appState: AppState
    @State var isPresentingResultView = false
    @State var isPresentingTutorialView = false
    @State private var canvasImage: UIImage?
    @State private var tmpHighlighted = false
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Look that way !")
                            .calligraphyFont(size: 48)
                        Text("あっち向いてホイ!")
                            .calligraphyFont(size: 32)
                        Spacer()
                    }
                    Spacer()
                    Button {
                        isPresentingTutorialView = true
                    } label: {
                        Text("?")
                            .calligraphyFont(size: 24)
                            .foregroundStyle(.white)
                            .padding(8)
                            .background {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.teal)
                                    .aspectRatio(1, contentMode: .fill)
                            }
                    }
                }
                HStack {
                    Spacer()
                    FaceOverlay(appState: appState)
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 150)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    Spacer()
                }

            }
            .frame(maxWidth: .infinity)
            .padding()
            VStack(spacing: 4) {
                ZStack {
                    HStack {
                        Spacer()
                        VStack {
                            Text("Detected Your Face Direction")
                                .calligraphyFont(size: 24)
                            FaceView(appState: appState, cpuIndex: 5)
                                .aspectRatio(1, contentMode: .fit)
                                .padding(4)
                                .background {
                                    RoundedRectangle(cornerRadius: 16)
                                        .stroke(style: StrokeStyle(lineWidth: 4))
                                }
                        }
                        Spacer()
                    }
                    HStack {
                        Spacer()
                        Text("Having trouble with tracking? →\nFace forward and tap the button! →")
                            .font(.headline)
                        Button {
                            appState.shouldSetInitialFaceAngle = true
                        } label: {
                            Text("Re-center")
                                .foregroundStyle(.white)
                                .calligraphyFont(size: 24)
                                .padding()
                                .background {
                                    RoundedRectangle(cornerRadius: 24)
                                        .fill(Color.cyan)
                                }
                        }
                    }
                }
                .padding()
            }
            HStack {
                ZStack {
                    FaceView(appState: appState, cpuIndex: 0)
                        .aspectRatio(1, contentMode: .fit)
                    AnimatedCircleView(appState: appState, cpuIndex: 0)
                }
                Spacer()
                ZStack {
                    FaceView(appState: appState, cpuIndex: 1)
                        .aspectRatio(1, contentMode: .fit)
                    AnimatedCircleView(appState: appState, cpuIndex: 1)
                }
                Spacer()
                ZStack {
                    FaceView(appState: appState, cpuIndex: 2)
                        .aspectRatio(1, contentMode: .fit)
                    AnimatedCircleView(appState: appState, cpuIndex: 2)
                }
                Spacer()
                ZStack {
                    FaceView(appState: appState, cpuIndex: 3)
                        .aspectRatio(1, contentMode: .fit)
                    AnimatedCircleView(appState: appState, cpuIndex: 3)
                }
                Spacer()
                ZStack {
                    FaceView(appState: appState, cpuIndex: 4)
                        .aspectRatio(1, contentMode: .fit)
                    AnimatedCircleView(appState: appState, cpuIndex: 4)
                }
            }
            .padding()
            .frame(height: 150)
            Group {
                Text("Target number of faces")
                    .calligraphyFont(size: 24)
                Text("\"\(appState.matchNumber)\"")
                    .calligraphyFont(size: 56)
                    .bold()
            }

            CountdownGauge(countDown: appState.countdown)
                .frame(height: 40)
            ZStack {
                HStack {
                    Text("HP: \(appState.userHP)")
                    HPGauge(hp: appState.userHP)
                    Spacer()
                    Text("Point: \(appState.userPoint)")

                }
                .calligraphyFont(size: 32)
                .padding()
                HStack {
                    Button {
                        appState.resetAndStart()
                    } label: {
                        Text(appState.isPlaying ? "Restart" : "Start")
                            .calligraphyFont(size: 40)
                            .foregroundStyle(.white)
                            .padding(8)
                            .background(appState.isPlaying ? .orange : .green)
                            .clipShape(RoundedRectangle(cornerRadius: 24))
                    }

                    if appState.isPlaying {
                        Button {
                            appState.end()
                        } label: {
                            Text("End")
                                .calligraphyFont(size: 40)
                                .foregroundStyle(.white)
                                .padding(8)
                                .background(.red)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                        }
                    }
                }

            }
        }
        .onAppear {
            SoundManager.shared.playInitialBGM()
            isPresentingTutorialView = true
        }
        .onDisappear {
            SoundManager.shared.stopBGM()
        }
        .onChange(of: appState.userHP) {
            if appState.userHP == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isPresentingResultView = true
                    SoundManager.shared.playInitialBGM()
                }
            }
        }
        .sheet(isPresented: $isPresentingResultView) {
            ResultView(appState: appState)
        }
        .sheet(isPresented: $isPresentingTutorialView) {
            TutorialView(appState: appState)
        }
        .background {
            Image("game_bg")
                .resizable()
                .scaledToFill()
        }
    }
}
