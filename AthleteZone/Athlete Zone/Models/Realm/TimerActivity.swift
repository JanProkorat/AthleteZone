//
//  Timer.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 18.03.2024.
//

import Foundation
import RealmSwift

public class TimerActivity: Object, Identifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var interval: TimeInterval
    @Persisted var createdDate: Date

    public var id: String {
        self._id.stringValue
    }

    override public init() {
        self.interval = 0
        self.createdDate = Date()
    }

    init(interval: TimeInterval) {
        self.interval = interval
        self.createdDate = Date()
    }
}

extension TimerActivity {
    func toDto() -> TimerDto {
        return TimerDto(
            id: self.id,
            interval: self.interval
        )
    }
}
