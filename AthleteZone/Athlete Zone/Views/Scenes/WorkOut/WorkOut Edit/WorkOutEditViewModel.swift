//
//  WorkOutEditViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 25.02.2023.
//

import Foundation
import SwiftUI

class WorkOutEditViewModel: ObservableObject {
    var workout: WorkOut

    @Published var name: String
    @Published var work: Int
    @Published var rest: Int
    @Published var series: Int
    @Published var rounds: Int
    @Published var reset: Int
    @Published var isEditing = false

    var timeOverview: Int {
        (((work * series) + (rest * (series - 1)) + reset) * rounds) - reset
    }

    var saveDisabled: Bool {
        name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
            work == 0 || rest == 0 || series == 0 || rounds == 0 || reset == 0
    }

    var realmManager: WorkOutRealmManagerProtocol

    @ObservedObject var selectedWorkoutManager = SelectedWorkoutManager.shared

    var connectivityManager: WatchConnectivityProtocol
    var router: any ViewRoutingProtocol

    init() {
        let workout = WorkOut()
        self.workout = workout

        name = workout.name
        work = workout.work
        rest = workout.rest
        series = workout.series
        rounds = workout.rounds
        reset = workout.reset

        realmManager = WorkoutRealmManager()
        connectivityManager = WatchConnectivityManager.shared
        router = ViewRouter.shared
    }

    init(workout: WorkOut, _ work: Int, _ rest: Int, _ series: Int, _ rounds: Int, _ reset: Int) {
        self.workout = workout

        name = workout.name
        self.work = work
        self.rest = rest
        self.series = series
        self.rounds = rounds
        self.reset = reset

        realmManager = WorkoutRealmManager()
        connectivityManager = WatchConnectivityManager.shared
        router = ViewRouter.shared
    }

    init(workout: WorkOut) {
        self.workout = workout

        name = workout.name
        work = workout.work
        rest = workout.rest
        series = workout.series
        rounds = workout.rounds
        reset = workout.reset
        isEditing = true

        realmManager = WorkoutRealmManager()
        connectivityManager = WatchConnectivityManager.shared
        router = ViewRouter.shared
    }

    init(_ work: Int, _ rest: Int, _ series: Int, _ rounds: Int, _ reset: Int) {
        workout = WorkOut("", work, rest, series, rounds, reset)
        name = ""
        self.work = work
        self.rest = rest
        self.series = series
        self.rounds = rounds
        self.reset = reset

        realmManager = WorkoutRealmManager()
        connectivityManager = WatchConnectivityManager.shared
        router = ViewRouter.shared
    }

    func saveWorkout() {
        if !isEditing {
            let workout = WorkOut(name, work, rest, series, rounds, reset)
            realmManager.add(workout)
            connectivityManager.sendValue([TransferDataKey.workoutAdd.rawValue: workout.toDto().encode()!])

            if router.currentTab == .home {
                selectedWorkoutManager.selectedWorkout = workout
            }
        } else {
            realmManager.update(workout._id, name, work, rest, series, rounds, reset)
            connectivityManager.sendValue([TransferDataKey.workoutEdit.rawValue: workout.toDto().encode()!])

            if selectedWorkoutManager.selectedWorkout?._id == workout._id {
                selectedWorkoutManager.selectedWorkout = workout
            }
        }
    }
}
