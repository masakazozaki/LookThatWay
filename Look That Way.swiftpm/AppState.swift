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

    var countdown: CountdownTimer?

    var userPoint: Int = 0
    var userMaskImage: UIImage = .init()
    var userDrawing:Bool = false {
        didSet {
            if userDrawing == false {

            }
        }
    }
//: MARK: - FaceOverlayState
    var shouldSetInitialFaceAngle = false
    var faceDetected = false
    var userCurrentFaceDirection: FaceDirection = .front

    private func match() {
        var cpuDirections: [FaceDirection]
        switch userPoint {
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

        countdown = CountdownTimer(duration: max(1.3, 3 - log(Double(userPoint)+1)))
        print("duration:\(max(1.5, 3 - log(Double(userPoint)+1)))")
        countdown?.onFinish = { [weak self] in
            self?.judge()
        }
        cpuFaceDirections = cpuDirections
        countdown?.start()
    }

    private func countOccurrences(of directions: [FaceDirection]) -> [FaceDirection: Int] {
        var counts: [FaceDirection: Int] = [:]
        directions.forEach { counts[$0, default: 0] += 1 }
        return counts
    }

    private func findUniqueCombination(in counts: [FaceDirection: Int]) -> (FaceDirection, Int) {
        let uniqueCounts = counts.filter { entry1 in counts.filter { $0.value == entry1.value }.count == 1 }
        let randomUnique = uniqueCounts.randomElement()!
        return (randomUnique.key, randomUnique.value)
    }

    private func findTargetFaceDirection(_ directions: [FaceDirection]) -> (FaceDirection, Int) {
        let counts = countOccurrences(of: directions)
        return findUniqueCombination(in: counts)
    }


    func judge() {
        print("judge")
        if userCurrentFaceDirection == targetFaceDirection {
            userPoint += 1
            SoundManager.shared.playSound(name: "correct")
        } else {
            userHP -= 1
            SoundManager.shared.playSound(name: "incorrect")
        }
        if userHP > 0 {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.match()
            }
        } else {
            SoundManager.shared.playSound(name: "result")
        }
    }

    func resetAndStart() {
        userHP = 5
        matchNumber = 0
        userPoint = 0
        match()
    }

    func drawPencil() {
        userDrawing = true
    }

    func placeStickerToUser() {

    }
}
