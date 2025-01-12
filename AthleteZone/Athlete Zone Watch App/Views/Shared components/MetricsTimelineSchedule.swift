//
//  MetricsTimelineSchedule.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 12.09.2024.
//

import SwiftUI

struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date
    var interval: TimeInterval

    init(from startDate: Date, interval: TimeInterval) {
        self.startDate = startDate
        self.interval = interval
    }

    func entries(from startDate: Date, mode: TimelineScheduleMode) -> PeriodicTimelineSchedule.Entries {
        PeriodicTimelineSchedule(from: self.startDate, by: mode == .lowFrequency ? self.interval : 1.0 / 30.0)
            .entries(from: startDate, mode: mode)
    }
}
