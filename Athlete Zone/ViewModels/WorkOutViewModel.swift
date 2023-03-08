//
//  WorkOutViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 13.11.2022.
//

import Combine
import Foundation
import SwiftUI

class WorkOutViewModel: WorkOutCommonViewModel, ObservableObject {
    @ObservedObject var selectedWorkoutManager = SelectedWorkoutManager.shared

    private let realmManager = RealmManager()

    private var selectedWorkoutCancellable: AnyCancellable?

    override init() {
        super.init()

        selectedWorkoutCancellable = selectedWorkoutManager.$selectedWorkout.sink(receiveValue: { newValue in
            if let workout = newValue {
                self.setValues(workout)
                self.selectedWorkoutManager.selectedWorkout = nil
            }
        })
    }

    func loadWorkoutById(_ id: String) {
        let workout = realmManager.load(entity: WorkOut.self, primaryKey: id)
        if workout != nil {
            setValues(workout!)
        }
    }
}
