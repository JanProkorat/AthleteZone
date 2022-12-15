//
//  WorkOutViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 13.11.2022.
//

import Foundation
import RealmSwift

class WorkOutViewModel: ObservableObject {
    @Published var selectedWorkOut = WorkOut("Title", 40, 60, 3, 2, 60)

    let realmManager = RealmManager()

    func setSelectedWorkOut(_ workout: WorkOut) {
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

    func updateProperty<T>(_ workout: WorkOut, propertyName: String, value: T) {
        do {
            try realmManager.realm.write {
                if let intValue = value as? String {
                    workout[propertyName] = intValue
                } else if let intValue = value as? Int {
                    workout[propertyName] = intValue
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
