//
//  SoundManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 12.02.2023.
//

import AVKit
import Foundation

class SoundManager: SoundProtocol {
    private var audioSession: AVAudioSession?
    private var players: [Sound: AVAudioPlayer]

    var selectedSound: Sound?
    var isSoundPlaying: Bool {
        players.contains(where: { $0.value.isPlaying })
    }

    init() {
        players = [:]

        for sound in Sound.allCases {
            if let player = setupVideoPlayer(sound) {
                players[sound] = player
            }
        }

        setupAudioSession()
    }

    func playSound(sound: Sound, numOfLoops: Int) {
        selectedSound = sound
        if let player = players[sound] {
            player.numberOfLoops = numOfLoops
            player.play()
        }
    }

    func stop() {
        if let player = players[selectedSound!] {
            player.pause()
        }
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

    private func setupVideoPlayer(_ sound: Sound) -> AVAudioPlayer? {
        if let asset = NSDataAsset(name: sound.rawValue) {
            do {
                return try AVAudioPlayer(data: asset.data, fileTypeHint: "mp3")
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
        return nil
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
