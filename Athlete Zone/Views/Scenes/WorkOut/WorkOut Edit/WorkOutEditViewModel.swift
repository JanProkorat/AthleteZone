//
//  WorkOutEditViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 25.02.2023.
//

import Foundation

class WorkOutEditViewModel: WorkOutCommonViewModel, ObservableObject {
    var realmManager = WorkoutRealmManager()
    @Published var connectivityManager = WatchConnectivityManager.shared

    func save() {
        if _id == nil {
            let workout = WorkOut(name, work, rest, series, rounds, reset)
            realmManager.add(workout)
            _id = workout._id.stringValue
            connectivityManager.sendValue(["workout_add": workout.encode()])
        } else {
            let workout = realmManager.update(entity: WorkOut(_id!, name, work, rest, series, rounds, reset))
            if workout != nil {
                connectivityManager.sendValue(["workout_edit": workout!.encode()])
            }
        }
    }
}
