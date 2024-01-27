//
//  FaceOverlayView.swift
//  My App
//
//  Created by Masakaz Ozaki on 2024/01/27.
//
import ARKit
import UIKit
import SwiftUI


struct FaceOverlay: UIViewRepresentable {
    func makeUIView(context: Context) -> FaceOverlayView {
        return FaceOverlayView()
    }

    func updateUIView(_ uiView: FaceOverlayView, context: Context) {
        uiView.startFaceTracking()
    }
}

class FaceOverlayView: UIView, ARSCNViewDelegate {
    private var faceNode: SCNNode?
    private var maskImage: UIImage?
    private let sceneView = ARSCNView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSceneView()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSceneView()
    }

    private func initializeSceneView() {
        sceneView.delegate = self
        sceneView.showsStatistics = false
        sceneView.automaticallyUpdatesLighting = true
        sceneView.scene = SCNScene()
        addSubview(sceneView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        sceneView.frame = bounds
    }

    func startFaceTracking() {
        guard ARFaceTrackingConfiguration.isSupported else {
            print("Device does not support face tracking")
            return
        }

        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        maskImage = UIImage(named: "back")!
    }

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device, let faceAnchor = anchor as? ARFaceAnchor, faceNode == nil else {
            return nil
        }

        let faceGeometry = ARSCNFaceGeometry(device: device)
        faceNode = SCNNode(geometry: faceGeometry)
        faceNode!.geometry!.firstMaterial!.diffuse.contents = maskImage
        faceNode!.geometry!.firstMaterial!.lightingModel = .physicallyBased

        updateFaceNode(with: faceAnchor)

        return faceNode
    }

    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let faceAnchor = anchor as? ARFaceAnchor else { return }
        updateFaceNode(with: faceAnchor)
    }

    private func updateFaceNode(with faceAnchor: ARFaceAnchor) {
        let faceGeometry = faceNode?.geometry as? ARSCNFaceGeometry
        faceGeometry?.update(from: faceAnchor.geometry)
    }
}
