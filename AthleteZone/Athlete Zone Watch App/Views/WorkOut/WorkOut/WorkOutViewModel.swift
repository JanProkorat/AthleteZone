//
//  WorkOutViewModel.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 25.11.2023.
//

import Combine
import Foundation
import SwiftUI
//
// class WorkOutViewModel: ObservableObject {
//    @Published var number = 0
//
//    @Published var work = 0
//    @Published var rest = 0
//    @Published var series = 0
//    @Published var rounds = 0
//    @Published var reset = 0
//
//    @Published var isRunViewVisible = false
//
//    @ObservedObject var runViewModel = WatchWorkOutRunViewModel()
//
//    private var cancellables = Set<AnyCancellable>()
//
//    init() {
//        runViewModel.$state
//            .sink(receiveValue: { newValue in
//                if newValue == .quit {
//                    self.number = 0
//                    self.isRunViewVisible = false
//                }
//            })
//            .store(in: &cancellables)
//    }
//
//    func setupRunViewModel() {
//        runViewModel.setupViewModel(
//            workout: WorkoutDto(
//                id: "ID",
//                name: "Workout",
//                work: work,
//                rest: rest,
//                series: series,
//                rounds: rounds,
//                reset: reset,
//                createdDate: Date(),
//                workoutLength: 0
//            )
//        )
//
//        isRunViewVisible.toggle()
//    }
// }
