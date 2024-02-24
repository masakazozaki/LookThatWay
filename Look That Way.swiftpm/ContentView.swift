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
            FaceView(appState: appState, cpuIndex: 5)
            if let countdown = appState.countdown {
                CountdownGauge(countDown: countdown)
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
            }.frame(height: 200)
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
            Image("cloud_bg")
                .resizable()
                .scaledToFill()
        }
    }
}
