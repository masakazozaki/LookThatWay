//
//  FaceView.swift
//  Look That Way!
//
//  Created by Masakaz Ozaki on 2024/02/23.
//

import SceneKit
import SwiftUI

struct FaceView: View {
    private let iconScene: SCNScene = SCNScene(named: "Face_scn.scn")!

    @State private var basePitch: Double!
    @State private var baseRoll: Double!
    @State private var baseYaw: Double!
    @State private var orientation: UIInterfaceOrientation?

    var faceDirection: FaceDirection
    @Binding var isHighlighted: Bool
    var body: some View {
        ZStack {
            Color.clear
            SceneView(
                scene: iconScene,
                options: SceneView.Options(arrayLiteral: [
                    .allowsCameraControl,
                    .autoenablesDefaultLighting,
//                    .rendersContinuously,
                    .jitteringEnabled,
                    .temporalAntialiasingEnabled
                ])
            )
            .ignoresSafeArea()
            .aspectRatio(contentMode: .fit)
            .frame(width: 100, height: 100)
        }
//        .onChange(of: faceDirection) {
//            SCNTransaction.animationDuration = 0.2
//            let scale: Float = 1.0
//            iconScene.rootNode.scale = SCNVector3Make(scale, scale, scale)
//            switch faceDirection {
//            case .front:
//                iconScene.rootNode.eulerAngles = SCNVector3Make(0, 0, 0)
////                iconScene.rootNode.simdTransform.columns.0.y = 0
////                iconScene.rootNode.simdTransform.columns.2.z = 0
//            case .up:
//                iconScene.rootNode.eulerAngles = SCNVector3Make(40, 0, 0)
////                iconScene.rootNode.simdTransform.columns.0.y = 1
////                iconScene.rootNode.simdTransform.columns.2.z = 0
//            case .down:
//                iconScene.rootNode.eulerAngles = SCNVector3Make(-40, 0, 0)
////                iconScene.rootNode.simdTransform.columns.0.y =  -1
////                iconScene.rootNode.simdTransform.columns.2.z = 0
//            case .left:
//                iconScene.rootNode.simdTransform.columns.0.y =  0
//                iconScene.rootNode.simdTransform.columns.2.z = 1
//            case .right:
//                iconScene.rootNode.simdTransform.columns.0.y =  0
//                iconScene.rootNode.simdTransform.columns.2.z = -1
//            }
//        }
    }
}
