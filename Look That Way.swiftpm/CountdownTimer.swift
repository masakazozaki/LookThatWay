//
//  CountdownTimer.swift
//  Look That Way!
//
//  Created by Masakaz Ozaki on 2/16/24.
//

import Foundation

@Observable
class CountdownTimer {
    private var timer: Timer?
    private var totalTime: TimeInterval
    private var remainingTime: TimeInterval
    private var isPaused: Bool = false
    var onFinish: (() -> Void)?

    init(duration: TimeInterval) {
        self.totalTime = duration
        self.remainingTime = duration
    }

    func start() {
        if isPaused {
            isPaused = false
            runTimer()
        } else {
            remainingTime = totalTime
            runTimer()
        }
    }

    private func runTimer() {
        timer?.invalidate() // 既存のタイマーを停止
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] timer in
            guard let self = self else { return }

            self.remainingTime -= 0.1
            if self.remainingTime <= 0 {
                timer.invalidate()
                self.remainingTime = 0
                self.onFinish?()
            }
        }
    }

    func pause() {
        isPaused = true
        timer?.invalidate()
    }

    func end() {
        timer?.invalidate()
        timer = nil
        onFinish?()
    }
}
