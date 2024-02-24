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
                        Spacer()
                    }
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Look that way !")
                                .calligraphyFont(size: 48)
                            Text("あっち向いてホイ!")
                                .calligraphyFont(size: 32)

                        }
                        Spacer()
                        Button {
                            appState.shouldSetInitialFaceAngle = true
                        } label: {
                            Text("Re-Center")
                                .calligraphyFont(size: 32)
                                .foregroundStyle(.white)
                                .padding()
                                .background(.cyan)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                        }
                    }
                    .padding()
                }

            }
            HStack {
                Text("Your Face Direction →")
                    .calligraphyFont(size: 24)
                FaceView(appState: appState, cpuIndex: 5)
                    .aspectRatio(1, contentMode: .fit)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(style: StrokeStyle(lineWidth: 4))
                    }
                Text("Your Face Direction →")
                    .calligraphyFont(size: 24)
                    .opacity(0)
            }

            if let countdown = appState.countdown {
                CountdownGauge(countDown: countdown)
                    .frame(height: 40)
            }
            HStack {
                ZStack {
                    FaceView(appState: appState, cpuIndex: 0)
                    AnimatedCircleView(appState: appState, cpuIndex: 0)
                }
                ZStack {
                    FaceView(appState: appState, cpuIndex: 1)
                    AnimatedCircleView(appState: appState, cpuIndex: 1)
                }
                ZStack {
                    FaceView(appState: appState, cpuIndex: 2)
                    AnimatedCircleView(appState: appState, cpuIndex: 2)
                }
                ZStack {
                    FaceView(appState: appState, cpuIndex: 3)
                    AnimatedCircleView(appState: appState, cpuIndex: 3)
                }
                ZStack {
                    FaceView(appState: appState, cpuIndex: 4)
                    AnimatedCircleView(appState: appState, cpuIndex: 4)
                }
            }
            .frame(height: 150)
            HStack {
                Text("Target Number →")
                    .calligraphyFont(size: 24)
                Text("\"\(appState.matchNumber)\"")
                    .calligraphyFont(size: 56)
                    .bold()
                Text("Target Number →")
                    .calligraphyFont(size: 24)
                    .opacity(0)
            }

            ZStack {
                HStack {
                    Text("HP: \(appState.userHP)")
                    HPGauge(hp: appState.userHP)
                    Spacer()
                    Text("Point: \(appState.userPoint)")

                }
                .calligraphyFont(size: 32)
                .padding()
                Button {
                    appState.resetAndStart()
                    SoundManager.shared.playSound(name: "start")
                } label : {
                    Text("Start")
                        .calligraphyFont(size: 40)
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
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    isPresentingResultView = true
                    SoundManager.shared.playInitialBGM()
                }
            }
        }
        .sheet(isPresented: $isPresentingResultView) {
            ResultView(appState: appState)
        }
        .background {
            Image("game_bg")
                .resizable()
                .scaledToFill()
        }
    }
}
