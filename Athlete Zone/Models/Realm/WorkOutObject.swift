//
//  WorkOut.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 24.11.2022.
//

import Foundation
import RealmSwift

class WorkOutObject: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var work: Int = 0
    @Persisted var rest: Int = 0
    @Persisted var series: Int = 0
    @Persisted dynamic var rounds: Int = 0
    @Persisted dynamic var reset: Int = 0
}
