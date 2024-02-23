//
//  FaceDirection.swift
//  Look That Way!
//
//  Created by Masakaz Ozaki on 2024/02/24.
//

import SwiftUI

enum FaceDirection: CaseIterable {
    case front
    case up
    case down
    case left
    case right

    var faceImage: Image {
        switch self {
        case .front:
            Image("front")
        case .up:
            Image("up")
        case .down:
            Image("down")
        case .left:
            Image("left")
        case .right:
            Image("right")
        }
    }

    var fingerText: Text {
        switch self {
        case .front:
            Text("🫵")
        case .up:
            Text("👆")
        case .down:
            Text("👇")
        case .left:
            Text("👈")
        case .right:
            Text("👉")
        }
    }

    static func random() -> FaceDirection {
        return FaceDirection.allCases.randomElement()!
    }
    static func randomExcludingFront() -> FaceDirection {
        let excludingFront = FaceDirection.allCases.filter { $0 != .front }
        return excludingFront.randomElement()!
    }
}
