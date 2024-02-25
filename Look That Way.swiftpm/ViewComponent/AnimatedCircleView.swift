//
//  AnimatedCircleView.swift
//  Look That Way!
//
//  Created by Masakaz Ozaki on 2024/02/24.
//

import SwiftUI

struct AnimatedCircleView: View {
    @State private var isShowing = false
    var appState: AppState
    var cpuIndex: Int
    var color: Color {
        if appState.history.last ?? false {
            return .green
        } else {
            return .red
        }
    }

    var body: some View {
        Circle()
            .trim(from: 0, to: isShowing ? 1 : 0)
            .stroke(color, lineWidth: 8)
            .shadow(color: color,radius: 2)
            .rotationEffect(Angle(degrees: isShowing ? 360 : 0))
            .animation(Animation.easeOut(duration: 1), value: isShowing)
            .onChange(of: appState.isMatching) {
                guard appState.isMatching == false else { return }
                if appState.targetFaceDirection == appState.cpuFaceDirections[cpuIndex] {
                    isShowing = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { 
                        self.isShowing = false
                    }
                }
            }
    }
}
