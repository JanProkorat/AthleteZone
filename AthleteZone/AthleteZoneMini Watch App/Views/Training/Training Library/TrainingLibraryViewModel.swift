//
//  TrainingLibraryViewModel.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 23.08.2023.
//

import Foundation

class TrainingLibraryViewModel: ObservableObject {
    @Published var library: [Training] = []

    @Published var sortByProperty: TrainingSortByProperty = .name
    @Published var sortOrder: SortOrder = .ascending

    @Published var selectedTraining: Training?

    func setSelectedTraining(_ training: Training) {
        selectedTraining = training
    }

    func setLibrary(_ trainings: [Training]) {
        library = trainings
    }

    func getSortedArray() -> [Training] {
        var result: [Training]
        switch sortByProperty {
        case .name:
            result = library.sorted { $0.name > $1.name }

        case .createdDate:
            result = library.sorted { $0.createdDate > $1.createdDate }

        case .numOfWorkouts:
            result = library.sorted { $0.workoutCount > $1.workoutCount }

        case .trainingLength:
            result = library.sorted { $0.trainingLength > $1.trainingLength }
        }

        return sortOrder == .ascending ? result.reversed() : result
    }

    func addTraining(_ training: Training) {
//        if library != nil {
//            library.append(workout)
//        }
//        else {
//            library = [workout]
//        }
        library.append(training)
    }

    func updateTraining(_ training: Training) {
        library = library.map {
            if $0._id == training._id {
                $0.name = training.name
                $0.trainingDescription = training.trainingDescription
                $0.workouts = training.workouts
            }
            return $0
        }
    }

    func removeTraining(_ trainingId: String) {
        library.removeAll { $0._id.stringValue == trainingId }
    }
}
