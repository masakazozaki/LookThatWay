//
//  SoundManager.swift
//  Look That Way!
//
//  Created by Masakaz Ozaki on 2/16/24.
//

import AVFoundation
import UIKit
class SoundManager {
    static let shared = SoundManager() // シングルトンインスタンス
    private var audioPlayer: AVAudioPlayer?
    private var bgmPlayer: AVAudioPlayer?

    func playSound(name: String) {
        if let musicAsset = NSDataAsset(name: name) {
            do {
                audioPlayer = try AVAudioPlayer(data: musicAsset.data)
                audioPlayer?.play()
            } catch {
                print("サウンドファイルの再生に失敗しました。", error)
            }
        }
    }

    func playInitialBGM() {
        if let bgmAsset = NSDataAsset(name: "harunoumi") {
            do {
                bgmPlayer?.stop()
                bgmPlayer = try AVAudioPlayer(data: bgmAsset.data)
                bgmPlayer?.numberOfLoops = -1
                bgmPlayer?.volume = 0.05
                bgmPlayer?.play()
            } catch {
                print("BGMの再生に失敗しました。", error)
            }
        }
    }

    func playGameBGM() {
        if let bgmAsset = NSDataAsset(name: "sakurasakura") {
            do {
                bgmPlayer?.stop()
                bgmPlayer = try AVAudioPlayer(data: bgmAsset.data)
                bgmPlayer?.numberOfLoops = -1
                bgmPlayer?.volume = 0.05
                bgmPlayer?.play()
            } catch {
                print("BGMの再生に失敗しました。", error)
            }
        }
    }

    func stopBGM() {
        bgmPlayer?.stop()
        bgmPlayer = nil
    }
}
