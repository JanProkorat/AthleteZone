//
//  Timer.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import Foundation
import SwiftData

@Model class StopWatch: Identifiable {
    @Attribute(.unique) let id = UUID()
    @Attribute(.spotlight) var name = "Activity"
    var startDate: Date
    var endDate: Date
    var interval: TimeInterval
    var splitTimes: [TimeInterval]

    var activityLength: TimeInterval {
        self.endDate.timeIntervalSince(self.startDate)
    }

    init(startDate: Date, endDate: Date, interval: TimeInterval, splitTimes: [TimeInterval]) {
        self.startDate = startDate
        self.endDate = endDate
        self.interval = interval
        self.splitTimes = splitTimes
    }
}

extension StopWatch {
    func toDto() -> StopwatchDto {
        return StopwatchDto(
            id: self.id.uuidString,
            name: self.name,
            startDate: self.startDate,
            endDate: self.endDate,
            interval: self.interval,
            splitTimes: self.splitTimes
        )
    }
}
