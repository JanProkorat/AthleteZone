//
//  ViewModel.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 10.01.2023.
//

import Combine
import Foundation
import SwiftUI
//
// class WorkOutLibraryViewModel: ObservableObject {
//    @Published var library: [WorkoutDto] = []
//    @Published var selectedWorkOut: WorkoutDto?
//
//    @Published var sortByProperty: WorkOutSortByProperty = .name
//    @Published var sortOrder: SortOrder = .ascending
//    @ObservedObject var runViewModel = WatchWorkOutRunViewModel()
//
//    private var cancellables = Set<AnyCancellable>()
//
//    init() {
//        runViewModel.$state
//            .sink(receiveValue: { newValue in
//                if newValue == .quit {
//                    self.selectedWorkOut = nil
//                }
//            })
//            .store(in: &cancellables)
//    }
//
//    func setSelectedWorkOut(_ workout: WorkoutDto) {
//        selectedWorkOut = workout
//    }
//
//    func setLibrary(_ workouts: [WorkoutDto]) {
//        library = workouts
//    }
//
//    func getSortedArray() -> [WorkoutDto] {
//        var result: [WorkoutDto]
//        switch sortByProperty {
//        case .name:
//            result = library.sorted { $0.name > $1.name }
//
//        case .work:
//            result = library.sorted { $0.work > $1.work }
//
//        case .rest:
//            result = library.sorted { $0.rest > $1.rest }
//
//        case .series:
//            result = library.sorted { $0.series > $1.series }
//
//        case .rounds:
//            result = library.sorted { $0.rounds > $1.rounds }
//
//        case .reset:
//            result = library.sorted { $0.reset > $1.reset }
//
//        case .createdDate:
//            result = library.sorted { $0.createdDate > $1.createdDate }
//
//        case .workoutLength:
//            result = library.sorted { $0.workoutLength > $1.workoutLength }
//        }
//
//        return sortOrder == .ascending ? result.reversed() : result
//    }
//
//    func addWorkout(_ workout: WorkoutDto) {
//        library.append(workout)
//    }
//
//    func updateWorkout(_ workout: WorkoutDto) {
//        library = library.map {
//            if $0.id == workout.id {
//                return workout
//            }
//            return $0
//        }
//    }
//
//    func removeWorkout(_ workoutId: String) {
//        library.removeAll { $0.id == workoutId }
//    }
//
//    func setupRunViewModel(_ workout: WorkoutDto) {
//        runViewModel.setupViewModel(workout: workout)
//        selectedWorkOut = workout
//    }
// }
