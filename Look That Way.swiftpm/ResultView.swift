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
            Text("YOUR POINT")
                .font(.headline)
            Text("\(appState.userPoint)")
                .font(.largeTitle)
                .bold()
            Spacer()
            Button {
                dismiss()
            } label: {
                Text("RETRY")
            }
        }
    }
}
