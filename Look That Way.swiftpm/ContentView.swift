import SwiftUI

struct ContentView: View {
    var appState: AppState
    @State var isPresentingResultView = false
    @State private var canvasImage: UIImage?
    @State private var tmpHighlighted = false
    @State private var showingAlert = false
    var body: some View {
        VStack {
            GeometryReader { proxy in
                HStack {
                    VStack(alignment: .leading) {
                        Text("Look that way !")
                            .calligraphyFont(size: 48)
                        Text("あっち向いてホイ!")
                            .calligraphyFont(size: 32)
                        Text("Let's face the direction that matches the number of computers facing it, as indicated by the target number!")
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.title2)
                            .bold()
                    }
                    .frame(width: proxy.size.width / 2 - 75)
                    .frame(maxHeight: .infinity)
                    FaceOverlay(appState: appState)
                        .aspectRatio(1, contentMode: .fit)
                        .frame(width: 150)
                    VStack {
                        Text("For better face tracking, remove your \(Image(systemName: "facemask")) and \(Image(systemName: "visionpro")).")
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.headline)
                        Spacer()
                        Text("Before starting the game, place your iPad in front of you, tap \"Re-center\" to perform calibration, and ensure it accurately recognizes the direction of your face.")
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                            .font(.headline)
                    }
                    .frame(width: proxy.size.width / 2 - 75)
                }
            }
            .padding()
            VStack(spacing: 4) {
                ZStack {
                    HStack {
                        Spacer()
                        VStack {
                            Text("Your Face Direction")
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
                Text("Target Number")
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
                Button {
                    showingAlert = true
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
        .alert(isPresented: $showingAlert) {
            Alert(
                title: Text("Face Recognition Comfirmation"),
                message: Text("Is your face direction correctly recognized?"),
                primaryButton: .default(Text("Yes!")) {
                    appState.resetAndStart()
                    SoundManager.shared.playSound(name: "start")
                },
                secondaryButton: .cancel(Text("Not yet.")) {

                }
            )
        }
    }
}
