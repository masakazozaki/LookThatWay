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
    var appState: AppState
    func makeUIView(context: Context) -> FaceOverlayView {
        return FaceOverlayView(appState: appState)
    }

    func updateUIView(_ uiView: FaceOverlayView, context: Context) {
        uiView.startFaceTracking()
    }
}

class FaceOverlayView: UIView, ARSCNViewDelegate {
    var appState: AppState
    private var faceNode: SCNNode?
    private var maskImage: UIImage?
    private let sceneView = ARSCNView()
    var initialYaw: Float = 0
    var initialPitch: Float = 0

    private var calibrateButton = UIButton()

    private var currentAngleLabel = UILabel()


    init(appState: AppState) {
        self.appState = appState
        super.init(frame: .zero)
        initializeSceneView()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeSceneView() {
        sceneView.delegate = self
        sceneView.showsStatistics = false
        sceneView.automaticallyUpdatesLighting = true
        sceneView.scene = SCNScene()
        sceneView.debugOptions = [.showWorldOrigin]
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
        faceNode = nil

        let configuration = ARFaceTrackingConfiguration()
        configuration.isLightEstimationEnabled = true
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])

        maskImage = UIImage(named: "back")!
    }

    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        guard let device = sceneView.device, let faceAnchor = anchor as? ARFaceAnchor, faceNode == nil else {
            print("node for return nil")
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
        guard let faceAnchor = anchor as? ARFaceAnchor else {
            print("did update return nil")
            return
        }
        updateFaceNode(with: faceAnchor)

        if appState.shouldSetInitialFaceAngle {
            setInitialAngle(faceAnchor: faceAnchor)
            appState.shouldSetInitialFaceAngle = false
        }
        DispatchQueue.main.async {
            self.updateFaceDirection(faceAnchor: faceAnchor)
        }
    }

    private func updateFaceNode(with faceAnchor: ARFaceAnchor) {
        let faceGeometry = faceNode?.geometry as? ARSCNFaceGeometry
        faceGeometry?.update(from: faceAnchor.geometry)
    }

    func updateFaceDirection(faceAnchor: ARFaceAnchor) {
        let yaw = faceAnchor.transform.columns.0.z
        let pitch = faceAnchor.transform.columns.2.y

        let deltaYaw = yaw - initialYaw
        let deltaPitch = pitch - initialPitch
        print(deltaPitch, "pitch up down")
        print(deltaYaw, "yaw LR")

        // 絶対値が大きい方の変化を判断
        if abs(deltaYaw) > abs(deltaPitch) {
            // Yawの変化が大きい場合
            if deltaYaw > 0.2 {
                appState.userCurrentFaceDirection = .left
                currentAngleLabel.text = "👈"
                print("顔は左を向いています")
            } else if deltaYaw < -0.2 {
                appState.userCurrentFaceDirection = .right
                currentAngleLabel.text = "👉"
                print("顔は右を向いています")
            }
        } else {
            // Pitchの変化が大きい場合
            if deltaPitch > 0.2 {
                appState.userCurrentFaceDirection = .up
                currentAngleLabel.text = "☝️"
                print("顔は上を向いています")
            } else if deltaPitch < -0.2 {
                appState.userCurrentFaceDirection = .down
                currentAngleLabel.text = "👇"
                print("顔は下を向いています")
            }
        }

        // どちらの変化も小さい場合は正面を向いていると判断
        if abs(deltaYaw) <= 0.2 && abs(deltaPitch) <= 0.2 {
            appState.userCurrentFaceDirection = .front
            currentAngleLabel.text = "🫵"
            print("顔は正面を向いています")
        }
    }

    func setInitialAngle(faceAnchor: ARFaceAnchor) {
        startFaceTracking()
        initialYaw = faceAnchor.transform.columns.0.z
        initialPitch = faceAnchor.transform.columns.2.y
        print("set initial angle!")
    }
}
