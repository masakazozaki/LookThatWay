//
//  AppState.swift
//  My App
//
//  Created by Masakaz Ozaki on 1/29/24.
//

import UIKit

@Observable
class AppState {
    var cpuFaceDirection: FaceDirection = .front
    var cpuPoint: Int = 0
    var cpuMaskImage: UIImage = .init()

    var userSelectedFaceDirection: FaceDirection = .front
    var userPoint: Int = 0
    var userMaskImage: UIImage = .init()
    var userDrawing:Bool = false {
        didSet {
            if userDrawing == false {
                
            }
        }
    }

    func match(_ userFaceDirection: FaceDirection) {
        let newCpuFaceDirection = FaceDirection.random()
        let isUserserWin = isUserWin(cpuFaceDirection: newCpuFaceDirection, userFaceDirection: userFaceDirection)
        cpuFaceDirection = newCpuFaceDirection
        if isUserserWin {
            userPoint += 1
        } else {
            cpuPoint += 1
        }
    }

    func isUserWin(cpuFaceDirection: FaceDirection, userFaceDirection: FaceDirection) -> Bool {
        return userFaceDirection == cpuFaceDirection
    }

    func drawPencil() {
        userDrawing = true
    }

    func placeStickerToUser() {

    }
}
