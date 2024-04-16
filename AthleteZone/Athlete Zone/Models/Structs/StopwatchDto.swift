//
//  StopwatchDto.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 06.03.2024.
//

import Foundation

struct StopwatchDto: Identifiable {
    var id: String
    var name: String
    var startDate: Date
    var endDate: Date
    var interval: TimeInterval
    var splitTimes: [TimeInterval]

    init(id: String, name: String, startDate: Date, endDate: Date, interval: TimeInterval, splitTimes: [TimeInterval]) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.splitTimes = splitTimes
        self.interval = interval
    }
}
