//
//  Game.swift
//  Look That Way!
//
//  Created by Masakaz Ozaki on 2024/01/29.
//

import SwiftUI

struct Game: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        VStack {
            Points()
                .environment(appState)
            Spacer()
            appState.cpuFaceDirection.faceImage
            FingerControl()
        }
    }
}

#Preview {
    Game()
}

struct Points: View {
    @Environment(AppState.self) private var appState
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
    @Environment(AppState.self) private var appState
    var body: some View {
        VStack {
            Button {
                appState.userSelectedFaceDirection = .up
                appState.match(.up)
            } label: {
                Text("👆")
                    .font(.largeTitle)
            }
            HStack {
                Button {
                    appState.userSelectedFaceDirection = .left
                    appState.match(.left)

                } label: {
                    Text("👈")
                        .font(.largeTitle)
                }
                //Button as a Space
                Button {
                    appState.userSelectedFaceDirection = .up
                    appState.match(.up)
                } label: {
                    Text("👆")
                        .font(.largeTitle)
                }
                .opacity(0)
                .disabled(true)
                Button {
                    appState.userSelectedFaceDirection = .right
                    appState.match(.right)
                } label: {
                    Text("👉")
                        .font(.largeTitle)
                }
            }
            Button {
                appState.userSelectedFaceDirection = .down
                appState.match(.down)
            } label: {
                Text("👇")
                    .font(.largeTitle)
            }
        }
    }
}
