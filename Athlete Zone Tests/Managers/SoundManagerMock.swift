//
//  SoundManagerMock.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 18.03.2023.
//

@testable import Athlete_Zone
import Foundation

class SoundManagerMock: SoundProtocol {
    var playSoundSound = false

    func playSound(sound: Sound) {
        playSoundSound = true
    }
}
