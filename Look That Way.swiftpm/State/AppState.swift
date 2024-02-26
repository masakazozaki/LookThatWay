//
//  AppState.swift
//  My App
//
//  Created by Masakaz Ozaki on 1/29/24.
//

import UIKit

@Observable
class AppState {
    var cpuFaceDirections: [FaceDirection] = [.front, .front, .front, .front, .front]
    var userHP: Int = 5
    var cpuMaskImage: UIImage = .init()
    var matchNumber: Int = 0
    var targetFaceDirection: FaceDirection = .front
    var isPlaying = false
    var isMatching = false
    var history = [Bool]()

    var countdown: CountdownTimer = CountdownTimer(duration: 3)
    var userPoint: Int = 0
    var userMaskImage: UIImage = .init()

    var recognizeTimer: CountdownTimer = CountdownTimer(duration: 0.3)

//: MARK: - FaceOverlayState
    var shouldSetInitialFaceAngle = false

    var userCurrentFaceDirection: FaceDirection = .front {
        didSet {
            recognizeTimer = CountdownTimer(duration: 0.6)
            print("set Reco Timer")
            if isMatching {
                if targetFaceDirection == userCurrentFaceDirection {
                    print("Start Reco timer")
                    recognizeTimer.onFinish = { [weak self] in
                        print("End Reco TImer")
                        if self?.isMatching == true {
                            self?.countdown.forceFinish()
                        }
                    }
                    recognizeTimer.start()
                }
            }
        }
    }
    var faceMaskImage = UIImage(named: "facemask_stroke")
    var targetMatchDuration = 3.0
    private func match() {
        if history.isEmpty {
            SoundManager.shared.playGameBGM(rate: 1.0)
            targetMatchDuration = 4.0
        } else if userPoint == 3 {
            SoundManager.shared.playGameBGM(rate: 1.5)
            targetMatchDuration = 3.0
        } else if userPoint == 6 {
            SoundManager.shared.playGameBGM(rate: 2.0)
            targetMatchDuration = 2.5
        } else if userPoint == 10 {
            SoundManager.shared.playGameBGM(rate: 2.5)
            targetMatchDuration = 2.0
        } else if userPoint == 15 {
            SoundManager.shared.playGameBGM(rate: 3.0)
            targetMatchDuration = 1.5
        }
        isPlaying = true
        isMatching = true
        SoundManager.shared.playSound(name: "next")
        var cpuDirections: [FaceDirection]
        switch history.count {
        case 0:
            //easy
            cpuDirections = [.down, .down, .up, .down, .down]
        case 1:
            //easy
            cpuDirections = [.up, .up, .left, .left, .left]
        case 2:
            //mid
            cpuDirections = [.right, .up, .up, .down, .down]
        case 3:
            //easy
            cpuDirections = [.right, .left, .left, .left, .right]
        case 4:
            cpuDirections = [.up, .up, .up, .up, .up]
        default:
            cpuDirections = (1...5).map { _ in FaceDirection.randomExcludingFront() }
        }
        (targetFaceDirection, matchNumber) = findTargetFaceDirection(cpuDirections)

        countdown = CountdownTimer(duration: targetMatchDuration)
        countdown.onFinish = { [weak self] in
            self?.judge()
        }
        cpuFaceDirections = cpuDirections
        countdown.start()
    }

    private func countOccurrences(of directions: [FaceDirection]) -> [FaceDirection: Int] {
        var counts: [FaceDirection: Int] = [:]
        directions.forEach { counts[$0, default: 0] += 1 }
        return counts
    }

    private func findUniqueCombination(in counts: [FaceDirection: Int]) -> (FaceDirection, Int) {
        let frequencyMap = counts.values.reduce(into: [:]) { $0[$1, default: 0] += 1 }
        let uniqueCounts = counts.filter { frequencyMap[$0.value] == 1 }
        //5個から選ぶので必ず存在するのでforce-unwrap
        let randomPick = uniqueCounts.randomElement()!
        return (randomPick.key, randomPick.value)
    }

    private func findTargetFaceDirection(_ directions: [FaceDirection]) -> (FaceDirection, Int) {
        let counts = countOccurrences(of: directions)
        return findUniqueCombination(in: counts)
    }

    func judge() {
        print("judge")
        isMatching = false
        if userCurrentFaceDirection == targetFaceDirection {
            userPoint += 1
            history.append(true)
            SoundManager.shared.playSound(name: "correct")
        } else {
            faceMaskImage = faceMaskImage?.addRandomSticker()
            userHP -= 1
            history.append(false)
            SoundManager.shared.playSound(name: "incorrect")
        }
        if userHP > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                self?.match()
            }
        } else {
            SoundManager.shared.playSound(name: "result")
            isPlaying = false
        }
    }

    func resetAndStart() {
        isPlaying = true
        userHP = 5
        matchNumber = 0
        userPoint = 0
        history = []
        faceMaskImage = UIImage(named: "facemask_stroke")
        shouldSetInitialFaceAngle = true
        match()
    }

    func end() {
        isPlaying = false
        countdown.invalidate()
        userHP = 0

    }
}
