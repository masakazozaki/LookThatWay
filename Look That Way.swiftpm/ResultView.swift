//
//  ResultView.swift
//  Look That Way!
//
//  Created by Masakaz Ozaki on 2024/02/23.
//

import SwiftUI

struct ResultView: View {
    @Environment(\.dismiss) var dismiss
    var appState: AppState
    var body: some View {
        VStack {
            Spacer()
            Text("YOUR POINT")
                .calligraphyFont(size: 24)
            Text("\(appState.userPoint)")
                .calligraphyFont(size: 40)
            FaceOverlay(appState: appState)
                .aspectRatio(1, contentMode: .fit)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .shadow(color: .cyan, radius: 24)
                .frame(width: 300)
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("RETRY")
                    .calligraphyFont(size: 16)
                    .foregroundColor(.white)
                    .padding()
                    .background {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color.indigo)
                    }
            }
            Spacer()
        }
        .background {
            Image("game_bg")
                .resizable()
                .scaledToFill()
        }
    }
}
