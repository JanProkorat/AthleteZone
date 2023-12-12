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
    @Persisted var splitTimes: RealmSwift.List<TimeInterval>

    public var id: String {
        _id.stringValue
    }

    override public init() {
        startDate = Date()
        endDate = Date()
        name = "Activity"
        splitTimes = RealmSwift.List<TimeInterval>()
    }

    init(startDate: Date, endDate: Date, splitTimes: [TimeInterval]) {
        self.startDate = startDate
        self.endDate = endDate
        name = "Activity"
        let times = RealmSwift.List<TimeInterval>()
        times.append(objectsIn: splitTimes)
        self.splitTimes = times
    }
}
