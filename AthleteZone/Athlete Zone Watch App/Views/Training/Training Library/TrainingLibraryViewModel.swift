//
//  TrainingLibraryViewModel.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 23.08.2023.
//
//
//import Combine
//import Foundation
//import SwiftUI
//
//class TrainingLibraryViewModel: ObservableObject {
//    @Published var library: [TrainingDto] = []
//
//    @Published var sortByProperty: TrainingSortByProperty = .name
//    @Published var sortOrder: SortOrder = .ascending
//
//    @Published var isRunSheetPresented = false
//
////    @ObservedObject var runViewModel = TrainingRunViewModel()
//
//    private var cancellables = Set<AnyCancellable>()
//
//    init() {
////        runViewModel
////            .$closeSheet
////            .sink { close in
////                if close {
////                    self.isRunSheetPresented.toggle()
////                }
////            }
////            .store(in: &cancellables)
//    }
//
//    func setLibrary(_ trainings: [TrainingDto]) {
//        library = trainings
//    }
//
//    func getSortedArray() -> [TrainingDto] {
//        var result: [TrainingDto]
//        switch sortByProperty {
//        case .name:
//            result = library.sorted { $0.name > $1.name }
//
//        case .createdDate:
//            result = library.sorted { $0.createdDate > $1.createdDate }
//
//        case .numOfWorkouts:
//            result = library.sorted { $0.workoutsCount > $1.workoutsCount }
//
//        case .trainingLength:
//            result = library.sorted { $0.trainingLength > $1.trainingLength }
//        }
//
//        return sortOrder == .ascending ? result.reversed() : result
//    }
//
//    func addTraining(_ training: TrainingDto) {
//        library.append(training)
//    }
//
//    func updateTraining(_ training: TrainingDto) {
//        library = library.map {
//            if $0.id == training.id {
//                return training
//            }
//            return $0
//        }
//    }
//
//    func removeTraining(_ trainingId: String) {
//        library.removeAll { $0.id == trainingId }
//    }
//
//    func setupViewModel(_ training: TrainingDto) {
////        runViewModel.setupViewModel(trainingName: training.name, workouts: training.workouts)
//        isRunSheetPresented.toggle()
//    }
//}
