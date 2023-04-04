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

    var workouts = List<WorkOut>()

    var workoutCount: Int {
        workouts.count
    }

    var trainingLength: Int {
        getTrainingLength()
    }

    override public init() {
        name = "Training"
        trainingDescription = "Test description. This is the place, where you can say something about the training."
        createdDate = Date()
        workouts.append(objectsIn: [WorkOut(), WorkOut(), WorkOut(),
                                    WorkOut(), WorkOut(), WorkOut(),
                                    WorkOut(), WorkOut(), WorkOut(),
                                    WorkOut(), WorkOut(), WorkOut(),
                                    WorkOut(), WorkOut(), WorkOut()])
    }

    func addWorkOuts(_ workouts: [WorkOut]) {
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
