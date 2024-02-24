//
//  CountdownGauge.swift
//  Look That Way!
//
//  Created by Masakaz Ozaki on 2/16/24.
//

import SwiftUI

struct CountdownGauge: View {
    var countDown: CountdownTimer
    @State private var isBlinking = false

    private func progress() -> CGFloat {
        CGFloat(countDown.remainingTime) / CGFloat(countDown.totalTime)
    }

    private func lampColor() -> Color {
        let progressValue = progress()
        switch progressValue {
        case 0..<0.3:
            return .red
        case 0.3..<0.5:
            return .yellow
        case 0.5...1:
            return .green
        default:
            return .green
        }
    }

    private func startBlinking() {
        guard progress() <= 0.25 else {
            isBlinking = false
            return
        }
        if progress() <= 0.0 {
            isBlinking = false
            return
        }
        isBlinking = true
    }

    var body: some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(lampColor())
                        .frame(width: max(geometry.size.width * progress() * 0.9, 0), height: 16)
                    Circle()
                        .fill(isBlinking ? .white : lampColor())
                        .frame(width: 32, height: 32)
                        .overlay(
                            Circle()
                                .stroke(.white, lineWidth: 4)
                        )
                        .animation(isBlinking ? .easeInOut(duration: 0.2).repeatForever(autoreverses: true) : .default, value: isBlinking)

                }
                Spacer()
            }

            .onChange(of: countDown.remainingTime) {
                startBlinking()
            }
        }
    }
}
