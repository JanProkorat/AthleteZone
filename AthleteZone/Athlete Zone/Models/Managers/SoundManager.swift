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
    private var audioSession: AVAudioSession?

    init() {
        setupAudioSession()
    }

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

    private func setupAudioSession() {
        audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession?.setCategory(.playback)
            try audioSession?.setActive(true)
        } catch {
            print("Failed to set up audio session: \(error.localizedDescription)")
        }
    }

    deinit {
        stop()
        do {
            try audioSession?.setActive(false)
        } catch {
            print("Failed to deactivate audio session: \(error.localizedDescription)")
        }
    }
}
