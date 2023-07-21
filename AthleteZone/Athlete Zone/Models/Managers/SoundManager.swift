//
//  SoundManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 12.02.2023.
//

import AVKit
import Foundation

class SoundManager: SoundProtocol {
    private var audioPlayer: AVAudioPlayer?

    func playSound(sound: Sound) {
        if let asset = NSDataAsset(name: sound.rawValue) {
            do {
                audioPlayer = try AVAudioPlayer(data: asset.data, fileTypeHint: "mp3")
                audioPlayer?.play()
            } catch {
                print(error.localizedDescription)
            }
        }
    }

    func stop() {
        audioPlayer?.pause()
        audioPlayer = nil
    }
}
