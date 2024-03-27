//
//  Timer.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import Foundation
import RealmSwift

public class StopWatch: Object, Identifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var startDate: Date
    @Persisted var endDate: Date
    @Persisted var interval: TimeInterval
    @Persisted var splitTimes: RealmSwift.List<TimeInterval>

    public var id: String {
        self._id.stringValue
    }

    override public init() {
        self.startDate = Date()
        self.endDate = Date()
        self.name = "Activity"
        self.interval = 0
        self.splitTimes = RealmSwift.List<TimeInterval>()
    }

    init(startDate: Date, endDate: Date, interval: TimeInterval, splitTimes: [TimeInterval]) {
        self.startDate = startDate
        self.endDate = endDate
        self.name = "Activity"
        self.interval = interval
        let times = RealmSwift.List<TimeInterval>()
        times.append(objectsIn: splitTimes)
        self.splitTimes = times
    }
}

extension StopWatch {
    func toDto() -> StopwatchDto {
        return StopwatchDto(
            id: self.id,
            name: self.name,
            startDate: self.startDate,
            endDate: self.endDate,
            interval: self.interval,
            splitTimes: Array(self.splitTimes)
        )
    }
}
