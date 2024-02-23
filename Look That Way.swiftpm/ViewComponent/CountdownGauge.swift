//
//  CountdownGauge.swift
//  Look That Way!
//
//  Created by Masakaz Ozaki on 2/16/24.
//

import SwiftUI

struct CountdownGauge: View {
    var countDown: CountdownTimer

    private func circleColor(for position: Int) -> Color {
        let progress = Double(countDown.remainingTime) / Double(countDown.totalTime)
        let activeCircles: Int

        switch progress {
        case 0..<0.25:
            activeCircles = 0
        case 0.25..<0.5:
            activeCircles = 2 // 中央の四つのうち外側の二つ
        case 0.5..<0.75:
            activeCircles = 4 // 中央の四つ
        case 0.75...1:
            activeCircles = 6 // 全部
        default:
            activeCircles = 0
        }

        // 中央からの距離に応じてアクティブか判断 (左右対称)
        let distanceFromCenter = abs(position - 3)
        return distanceFromCenter < activeCircles / 2 ? activeColor(progress: progress) : .gray
    }

    private func activeColor(progress: Double) -> Color {
        switch progress {
        case 0..<0.25:
            return .red
        case 0.25..<0.5:
            return .red
        case 0.5..<0.75:
            return .yellow
        case 0.75...1:
            return .green
        default:
            return .green
        }
    }

    var body: some View {
        HStack {
            ForEach(0...6, id: \.self) { index in
                Circle()
                    .fill(circleColor(for: index))
                    .frame(width: 20, height: 20)
            }
        }
    }
}
