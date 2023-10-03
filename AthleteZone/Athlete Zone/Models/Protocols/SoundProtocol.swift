//
//  SoundProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 12.02.2023.
//

import Foundation

protocol SoundProtocol {
    func playSound(sound: Sound, numOfLoops: Int)
    func stop()
}
