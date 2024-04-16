////
////  TrainingRealmManagerMock.swift
////  Athlete Zone Tests
////
////  Created by Jan Prokorát on 21.11.2023.
////
//
// @testable import Athlete_Zone
// import Foundation
// import RealmSwift
//
// class TrainingRealmManagerMock: TrainingRealmProtocol {
//    var objects: [Training] = []
//
//    func load() -> [Athlete_Zone.Training] {
//        return objects
//    }
//
//    func load(
//        _ searchText: String,
//        _ sortBy: Athlete_Zone.TrainingSortByProperty,
//        _ sortOrder: Athlete_Zone.SortOrder
//    ) -> [Athlete_Zone.Training] {
//        let filteredTrainings: [Training]
//        if searchText.isEmpty {
//            filteredTrainings = objects
//        } else {
//            filteredTrainings = objects.filter { training in
//                training.name.lowercased().contains(searchText.lowercased())
//            }
//        }
//
//        let sortedTrainings: [Training]
//        switch sortBy {
//        case .name:
//            sortedTrainings = filteredTrainings.sorted { training1, training2 in
//                sortOrder == .ascending ?
//                    training1.name < training2.name :
//                    training1.name > training2.name
//            }
//
//        case .createdDate:
//            sortedTrainings = filteredTrainings.sorted { training1, training2 in
//                sortOrder == .ascending ?
//                    training1.createdDate < training2.createdDate :
//                    training1.createdDate > training2.createdDate
//            }
//
//        case .numOfWorkouts:
//            sortedTrainings = filteredTrainings.sorted { training1, training2 in
//                sortOrder == .ascending ?
//                    training1.workoutCount < training2.workoutCount :
//                    training1.workoutCount > training2.workoutCount
//            }
//
//        case .trainingLength:
//            sortedTrainings = filteredTrainings.sorted { training1, training2 in
//                sortOrder == .ascending ?
//                    training1.trainingLength < training2.trainingLength :
//                    training1.trainingLength > training2.trainingLength
//            }
//        }
//
//        return sortedTrainings
//    }
//
//    func load(primaryKey: String) -> Athlete_Zone.Training? {
//        do {
//            let objectId = try ObjectId(string: primaryKey)
//            return objects.first(where: { $0._id == objectId })
//        } catch {
//            return nil
//        }
//    }
//
//    func delete(entity: Athlete_Zone.Training) {
//        let index = objects.firstIndex(where: { $0._id == entity._id })
//        if let removeIndex = index {
//            objects.remove(at: removeIndex)
//        }
//    }
//
//    func add(_ training: Athlete_Zone.Training) {
//        objects.append(training)
//    }
//
//    func update(
//        _ id: RealmSwift.ObjectId,
//        _ name: String,
//        _ description: String,
//        _ workouts: [Athlete_Zone.WorkOut]
//    ) {
//        guard let index = objects.firstIndex(where: { $0._id == id }) else {
//            return
//        }
//
//        objects[index].name = name
//        objects[index].trainingDescription = description
//
//        var list = List<WorkOut>()
//        list.append(objectsIn: workouts)
//        objects[index].workouts = list
//    }
// }
