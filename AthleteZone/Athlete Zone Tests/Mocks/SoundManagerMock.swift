//
//  SoundManagerMock.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 18.03.2023.
//

@testable import Athlete_Zone
import Foundation

class SoundManagerMock: SoundProtocol {
    private var isPlaying = false

    var selectedSound: Athlete_Zone.Sound?
    var isSoundPlaying: Bool {
        isPlaying
    }

    func playSound(sound: Athlete_Zone.Sound, numOfLoops: Int) {
        isPlaying = true
        selectedSound = sound
    }

    func stop() {
        isPlaying = false
    }
}
