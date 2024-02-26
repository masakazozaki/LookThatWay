//
//  TutorialView.swift
//  Look That Way!
//
//  Created by Masakaz Ozaki on 2024/02/26.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable var appState: AppState
    var body: some View {
        ScrollView(.vertical) {
            Spacer(minLength: 16)
            Text("Ho to Play")
                .calligraphyFont(size: 40)
            Text("1. Check the \"number of faces\"")
                .calligraphyFont(size: 24)
            Text("In this case, \"the number of faces\" is 4.")
                .font(.headline)
            Image("tutorial1")
                .resizable()
                .scaledToFit()
                .padding(.horizontal)
            Spacer(minLength: 40)
            Text("2. Find the direction in which the faces, as indicated by the \"number of faces\", are facing.")
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .calligraphyFont(size: 24)
            Text("In this case, as you know, there are 5 faces in total, and out of these, 4 are facing down.")
                .font(.headline)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            Image("tutorial2")
                .resizable()
                .scaledToFit()
                .padding(.horizontal)

            Spacer(minLength: 40)
            Text("3. All that's left is for you to face down towards the front camera.")
                .calligraphyFont(size: 24)
            Text("You will receive points for giving the correct answer.")
                .font(.headline)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            Image("tutorial3")
                .resizable()
                .scaledToFit()
                .padding(.horizontal)

            Spacer(minLength: 40)
            Text("For Better Face Tracking")
                .calligraphyFont(size: 40)
            Text("For better face tracking, remove your \(Image(systemName: "facemask")) and \(Image(systemName: "visionpro")).")
                .font(.headline)
            Spacer(minLength: 16)
            Text("Before starting the game, place your iPad in front of you, tap \"Re-center\" to perform calibration, and ensure it accurately recognizes the direction of your face.")
                .font(.headline)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .font(.headline)
            Image("tutorial4")
                .resizable()
                .scaledToFit()
                .padding(.horizontal)

            Button {
                dismiss()
            } label: {
                Text("Got it!")
                    .calligraphyFont(size: 24)
                    .foregroundStyle(.white)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.green)
                    }
            }
            Spacer(minLength: 16)
        }
    }
}
