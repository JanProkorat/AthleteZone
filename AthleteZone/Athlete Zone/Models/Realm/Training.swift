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

    var formattedCreatedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: createdDate)
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

    init(name: String, description: String, workouts: [WorkOut]) {
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

    func encode() -> String {
        do {
            let encodedData = try JSONEncoder().encode(self)
            let jsonString = String(data: encodedData, encoding: .utf8)
            return jsonString ?? ""
        } catch {
            print(error)
            return ""
        }
    }

    enum CodingKeys: String, CodingKey {
        case name, trainingDescription, createdDate, workouts
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(trainingDescription, forKey: .trainingDescription)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(workouts, forKey: .workouts)
    }
}

extension Training {
    func toDto() -> TrainingDto {
        return TrainingDto(
            id: _id.stringValue,
            name: name,
            trainingDescription: trainingDescription,
            workoutsCount: workouts.count,
            trainingLength: trainingLength,
            createdDate: createdDate,
            workouts: workouts.map { $0.toDto() }
        )
    }
}
