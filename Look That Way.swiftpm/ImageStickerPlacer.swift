//
//  ImageStickerPlacer.swift
//  Look That Way!
//
//  Created by Masakaz Ozaki on 2024/02/25.
//

import UIKit

extension UIImage {
    func addRandomSticker() -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: self.size)

        let stickeredImage = renderer.image { context in
            // 元の画像を描画
            self.draw(at: .zero)

            // スタンプ画像をランダムに選択
            let stickerName = "\((1...3).randomElement()!)" // スタンプ画像名
            if let stickerImage = UIImage(named: stickerName) {
                let randomSize = CGFloat((200...400).randomElement()!) // ランダムなサイズ
                let randomAngle = CGFloat(((-15)...15).randomElement()!) // ランダムな角度
                let randomX = CGFloat.random(in: 0...(self.size.width - randomSize))
                let randomY = CGFloat.random(in: 0...(self.size.height - randomSize))

                // コンテキストの保存
                context.cgContext.saveGState()

                // 回転と配置のためのトランスフォーム
                context.cgContext.translateBy(x: randomX + randomSize / 2, y: randomY + randomSize / 2)
                context.cgContext.rotate(by: randomAngle * CGFloat.pi / 180)
                context.cgContext.translateBy(x: -randomSize / 2, y: -randomSize / 2)
                stickerImage.draw(in: CGRect(x: 0, y: 0, width: randomSize, height: randomSize))
                context.cgContext.restoreGState()
            }
        }
        return stickeredImage
    }
}
