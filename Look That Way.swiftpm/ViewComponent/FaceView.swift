//
//  FaceView.swift
//  Look That Way!
//
//  Created by Masakaz Ozaki on 2024/02/23.
//

import SceneKit
import SwiftUI

struct FaceView: UIViewRepresentable {
    var appState: AppState
    var cpuIndex: Int

    func makeUIView(context: Context) -> SCNView {
        let scnView = SCNView()
        scnView.scene = SCNScene(named: "Face_scn.scn")!
        scnView.autoenablesDefaultLighting = true
        return scnView
    }

    func updateUIView(_ scnView: SCNView, context: Context) {
        // モデルの向きを更新する
        if let faceNode = scnView.scene?.rootNode {
            rotateFace(node: faceNode, direction: cpuIndex == 5 ? appState.userCurrentFaceDirection : appState.cpuFaceDirections[cpuIndex])
        }
    }

    // モデルの向きを変えるアニメーション
    private func rotateFace(node: SCNNode, direction: FaceDirection) {
        let angle: Float = .pi / 4
        var newAngles = node.eulerAngles

        switch direction {
        case .front:
            newAngles = SCNVector3(0, 0, 0) // No rotation
        case .up:
            newAngles = SCNVector3(-angle, 0, 0)
        case .down:
            newAngles = SCNVector3(angle, 0, 0)
        case .left:
            newAngles = SCNVector3(0, 0, -angle)
        case .right:
            newAngles = SCNVector3(0, 0, angle)
        }

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.1
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        node.eulerAngles = newAngles
        SCNTransaction.commit()
    }
}
