//
//  SoundManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 18.04.2024.
//

import AVFAudio
import Dependencies
import Foundation
import UIKit

struct AudioPlayer {
    static var shared = AudioPlayer()

    var players: [Sound: AVAudioPlayer] = [:]
    var playingSound: AVAudioPlayer? {
        players.first(where: { $0.value.isPlaying })?.value
    }

    var selectedSound: Sound? {
        players.first(where: { $0.value.isPlaying })?.key
    }

    var isPlaying: Bool {
        !players.isEmpty && playingSound != nil
    }

    mutating func setupPlayers() {
        for sound in Sound.allCases {
            guard let soundFileURL = Bundle.main.url(
                forResource: sound.rawValue,
                withExtension: "mp3"
            ) else {
                print("Sound \(sound.rawValue) not found")
                return
            }

            do {
                players[sound] = try AVAudioPlayer(
                    contentsOf: soundFileURL
                )
            } catch {
                print("Failed to setup player for sound \(sound.rawValue):", error.localizedDescription)
            }
        }
    }
}

struct SoundManager {
    var playSound: @Sendable (_ sound: Sound, _ numOfLoops: Int) -> Void
    var stopSound: @Sendable () -> Void
    var isPlaying: @Sendable () -> Bool
    var selectedSound: @Sendable () -> Sound?
}

extension SoundManager: DependencyKey {
    static var liveValue = Self(
        playSound: { sound, loops in
            if let player = AudioPlayer.shared.players[sound] {
                player.numberOfLoops = loops
                player.play()
            }
        },
        stopSound: {
            var audioPlayer = AudioPlayer.shared
            if !audioPlayer.isPlaying {
                return
            }
            audioPlayer.playingSound?.stop()
        },
        isPlaying: {
            AudioPlayer.shared.isPlaying
        },
        selectedSound: {
            AudioPlayer.shared.selectedSound
        }
    )
}
