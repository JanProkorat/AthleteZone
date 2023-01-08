//
//  WorkOutViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 13.11.2022.
//

import Foundation
import RealmSwift

class WorkOutViewModel: ObservableObject {
    @Published var selectedWorkOut: WorkOut?

    init(selectedWorkOut: WorkOut? = nil) {
        self.selectedWorkOut = selectedWorkOut
    }

    let realmManager = RealmManager()

    func setSelectedWorkOut(_ workout: WorkOut?) {
        selectedWorkOut = workout
    }

    func saveWorkOut(_ workOut: WorkOut) {
        realmManager.add(workOut)
        selectedWorkOut = workOut
    }

    func update(workOutToEdit: WorkOut, updatedWorkOut: WorkOut) {
        do {
            try realmManager.realm.write {
                workOutToEdit.name = updatedWorkOut.name
                workOutToEdit.work = updatedWorkOut.work
                workOutToEdit.rest = updatedWorkOut.rest
                workOutToEdit.series = updatedWorkOut.series
                workOutToEdit.rounds = updatedWorkOut.rounds
                workOutToEdit.reset = updatedWorkOut.reset
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func loadWorkoutById(_ id: ObjectId) -> WorkOut? {
        return realmManager.load(entity: WorkOut.self, primaryKey: id)
    }
}
