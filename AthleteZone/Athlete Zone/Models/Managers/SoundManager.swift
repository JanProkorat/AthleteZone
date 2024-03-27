//
//  SoundManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 12.02.2023.
//

import AVKit
import ComposableArchitecture
import Foundation

class SoundManager: SoundProtocol {
    var selectedSound: Sound?

    static let shared = SoundManager()

    private var audioSession: AVAudioSession?
    private var players: [Sound: AVAudioPlayer] = [:]

    var isSoundPlaying: Bool {
        players.values.contains { $0.isPlaying }
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

    private func setupPlayer(for sound: Sound) -> AVAudioPlayer? {
        guard let asset = NSDataAsset(name: sound.rawValue) else { return nil }
        do {
            return try AVAudioPlayer(data: asset.data, fileTypeHint: "mp3")
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func playSound(sound: Sound, numOfLoops: Int) {
        if isSoundPlaying, players[sound]?.isPlaying == true {
            return // Avoid replaying the same sound
        }
        if let player = players[sound] ?? setupPlayer(for: sound) {
            selectedSound = sound
            players[sound] = player
            player.numberOfLoops = numOfLoops
            player.play()
        }
    }

    func stop() {
        players.values.forEach { $0.pause() }
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

extension SoundManager: DependencyKey {
    static var liveValue: SoundProtocol = SoundManager.shared
}
