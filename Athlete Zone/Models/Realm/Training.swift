//
//  Training.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.03.2023.
//

import Foundation
import RealmSwift

@objcMembers
public class Training: Object, Identifiable, Codable {
    @Persisted(primaryKey: true) var _id: ObjectId

    @Persisted var name: String
    @Persisted var trainingDescription: String
    @Persisted var createdDate: Date
    @Persisted var workouts: RealmSwift.List<WorkOut>

    var workoutCount: Int {
        workouts.count
    }

    var trainingLength: Int {
        getTrainingLength()
    }

    override public init() {
        name = ""
        trainingDescription = ""
        createdDate = Date()
    }

    init(name: String, description: String, workouts: List<WorkOut>) {
        self.name = name
        trainingDescription = description

        let workOuts = RealmSwift.List<WorkOut>()
        workOuts.append(objectsIn: workouts)
        self.workouts = workOuts
    }

    func addWorkOuts(_ workouts: [WorkOut]) {
        self.workouts.removeAll()
        self.workouts.append(objectsIn: workouts)
    }

    private func getTrainingLength() -> Int {
        var result = 0
        for workout in workouts {
            result += workout.workoutLength
        }
        return result
    }
}
