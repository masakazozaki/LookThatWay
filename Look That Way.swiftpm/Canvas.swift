//
//  CanvasView.swift
//  My App
//
//  Created by Masakaz Ozaki on 2024/01/27.
//

import SwiftUI
import PencilKit

struct Canvas: UIViewRepresentable {
    @Binding var image: UIImage?
    var canvasView = PKCanvasView()

    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.tool = PKInkingTool(.watercolor, color: .black, width: 30)
        canvasView.drawingPolicy = .anyInput
        return canvasView
    }

    func updateUIView(_ uiView: PKCanvasView, context: Context) {}

    func saveImage() {
        UIGraphicsBeginImageContextWithOptions(canvasView.bounds.size, false, UIScreen.main.scale)
        canvasView.drawHierarchy(in: canvasView.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.image = image
    }
}
