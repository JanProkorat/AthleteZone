//
//  Timer.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 18.03.2024.
//

import Foundation
import SwiftData

@Model class TimerActivity: Identifiable {
    @Attribute(.unique) var id = UUID()
    @Attribute(.spotlight) var interval: TimeInterval
    @Attribute(.spotlight) var createdDate = Date()

    init(interval: TimeInterval) {
        self.interval = interval
    }
}

extension TimerActivity {
    func toDto() -> TimerDto {
        return TimerDto(
            id: self.id.uuidString,
            interval: self.interval
        )
    }
}
