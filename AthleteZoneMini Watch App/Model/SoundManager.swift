//
//  SoundManager.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 17.02.2023.
//

import AVFoundation
import Foundation

class SoundManager: SoundProtocol {
    private var audioPlayer: AVPlayer?

    func playSound(sound: Sound) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") else {
            print("File not found")
            return
        }

        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        audioPlayer = AVPlayer(playerItem: playerItem)
        audioPlayer!.play()
    }

    func stop() {
        audioPlayer?.pause()
        audioPlayer = nil
    }
}
