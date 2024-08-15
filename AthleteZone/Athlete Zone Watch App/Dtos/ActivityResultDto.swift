//
//  ActivityResultDto.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 29.07.2024.
//

import Foundation

struct ActivityResultDto: Identifiable {
    let id = UUID()
    var duration: TimeInterval
    var heartRate: Double
    var activeEnergy: Double
    var totalEnergy: Double
}
