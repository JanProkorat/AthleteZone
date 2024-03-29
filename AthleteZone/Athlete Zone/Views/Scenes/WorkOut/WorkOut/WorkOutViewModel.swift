//
//  WorkOutViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 13.11.2022.
//

import Combine
import Foundation
import SwiftUI
import WidgetKit

class WorkOutViewModel: ObservableObject, Identifiable {
    @ObservedObject var selectedWorkoutManager = SelectedWorkoutManager.shared
    @ObservedObject var runViewModel = PhoneWorkOutRunViewModel()

    var appStorageManager: any AppStorageProtocol
    var realmManager: WorkOutRealmManagerProtocol
    var router: any ViewRoutingProtocol

    @Published var selectedWorkout: WorkOut?
    @Published var name = ""
    @Published var work = 30
    @Published var rest = 60
    @Published var series = 5
    @Published var rounds = 3
    @Published var reset = 60
    @Published var scenePhase: ScenePhase?
    @Published var isRunViewVisible = false

    var timeOverview: Int {
        (((work * series) + (rest * series) + reset) * rounds) - reset
    }

    var isRunDisabled: Bool {
        work == 0 || rest == 0 || series == 0 || rounds == 0 || reset == 0
    }

    var selectedWorkoutUpdated: Bool {
        selectedWorkout != nil &&
            (work != selectedWorkout!.work || rest != selectedWorkout!.rest ||
                series != selectedWorkout!.series || rounds != selectedWorkout!.rounds ||
                reset != selectedWorkout!.reset)
    }

    private var cancellables = Set<AnyCancellable>()

    init() {
        router = ViewRouter.shared
        realmManager = WorkoutRealmManager()
        appStorageManager = AppStorageManager.shared

        selectedWorkoutManager.$selectedWorkout
            .sink(receiveValue: { newValue in
                if let workout = newValue {
                    self.selectedWorkout = newValue
                    self.name = workout.name
                    self.work = workout.work
                    self.rest = workout.rest
                    self.series = workout.series
                    self.rounds = workout.rounds
                    self.reset = workout.reset
                    self.storeWidgetData()
                } else if self.selectedWorkout != nil {
                    self.selectedWorkout = nil
                }
            })
            .store(in: &cancellables)

        $scenePhase
            .sink { self.storeSelectedWorkoutId($0) }
            .store(in: &cancellables)

        if selectedWorkoutManager.selectedWorkout == nil && !appStorageManager.selectedWorkoutId.isEmpty {
            selectedWorkoutManager.selectedWorkout = realmManager.load(
                primaryKey: appStorageManager.selectedWorkoutId
            )
        }

        runViewModel.$state
            .sink(receiveValue: { newValue in
                if newValue == .quit {
                    self.isRunViewVisible.toggle()
                }
            })
            .store(in: &cancellables)
    }

    func storeSelectedWorkoutId(_ scenePhase: ScenePhase?) {
        if scenePhase != nil && (scenePhase == .inactive || scenePhase == .background) && selectedWorkout != nil {
            appStorageManager.selectedWorkoutId = selectedWorkout!._id.stringValue
        }
    }

    func setupRunViewModel() {
        runViewModel.setupViewModel(workout: WorkOut(name, work, rest, series, rounds, reset))
        isRunViewVisible.toggle()
    }

    func storeWidgetData() {
        if let data = selectedWorkout?.toDto().encode() {
            appStorageManager.storeToUserDefaults(data: data, key: UserDefaultValues.workoutId)
            WidgetCenter.shared.reloadTimelines(ofKind: UserDefaultValues.widgetId.rawValue)
        }
    }

    func removeSelectedWorkout() {
        selectedWorkout = nil
        name = ""
    }
}
