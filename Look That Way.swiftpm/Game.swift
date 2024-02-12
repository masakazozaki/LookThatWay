//
//  Game.swift
//  Look That Way!
//
//  Created by Masakaz Ozaki on 2024/01/29.
//

import SwiftUI

struct Game: View {
    var appState: AppState

    var body: some View {
        VStack {
            Points(appState: appState)
                .environment(appState)
            Spacer()
            appState.cpuFaceDirection.faceImage
            FingerControl(appState: appState)
        }
    }
}

#Preview {
    Game(appState: .init())
}

struct Points: View {
    var appState: AppState
    var body: some View {
        HStack {
            VStack {
                Text("YOUR POINTS")
                Text("\(appState.userPoint)")
            }

            VStack {
                Text("CPU POINTS")
                Text("\(appState.cpuPoint)")
            }
        }
    }
}

struct FingerControl: View {
    var appState: AppState
    var body: some View {
        VStack {
            Button {
                appState.userCurrentFaceDirection = .up
                appState.match(.up)
            } label: {
                Text("👆")
                    .font(.largeTitle)
            }
            HStack {
                Button {
                    appState.userCurrentFaceDirection = .left
                    appState.match(.left)

                } label: {
                    Text("👈")
                        .font(.largeTitle)
                }
                //Button as a Space
                Button {
                    appState.userCurrentFaceDirection = .up
                    appState.match(.up)
                } label: {
                    Text("👆")
                        .font(.largeTitle)
                }
                .opacity(0)
                .disabled(true)
                Button {
                    appState.userCurrentFaceDirection = .right
                    appState.match(.right)
                } label: {
                    Text("👉")
                        .font(.largeTitle)
                }
            }
            Button {
                appState.userCurrentFaceDirection = .down
                appState.match(.down)
            } label: {
                Text("👇")
                    .font(.largeTitle)
            }
        }
    }
}
