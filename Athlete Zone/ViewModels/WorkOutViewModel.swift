//
//  WorkOutViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 13.11.2022.
//

import Combine
import Foundation
import RealmSwift

class WorkOutViewModel: ObservableObject {
    @Published var selectedWorkOut: WorkOut?
    @Published var connectivityManager = WatchConnectivityManager.shared
    @Published var appStorageManager = AppStorageManager.shared

    private let realmManager = RealmManager()

    init(selectedWorkOut: WorkOut? = nil) {
        self.selectedWorkOut = selectedWorkOut
    }

    func setSelectedWorkOut(_ workout: WorkOut?) {
        selectedWorkOut = workout
    }

    func saveWorkOut(_ workOut: WorkOut) {
        realmManager.add(workOut)
        selectedWorkOut = workOut
        connectivityManager.sendValue(["workout_add": workOut.encode()])
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
            connectivityManager.sendValue(["workout_edit": workOutToEdit.encode()])
        } catch {
            print(error.localizedDescription)
        }
    }

    func removeFromWatch(_ id: ObjectId) {
        connectivityManager.sendValue(["workout_remove": id.stringValue])
    }

    func loadWorkoutById(_ id: ObjectId) -> WorkOut? {
        return realmManager.load(entity: WorkOut.self, primaryKey: id)
    }

    func shareLanguage(_ language: Language) {
        connectivityManager.sendValue([DefaultItem.language.rawValue: language.rawValue])
    }

    func shareSoundsEnabled(_ enabled: Bool) {
        connectivityManager.sendValue([DefaultItem.soundsEnabled.rawValue: enabled])
    }

    func shareHapticsEnabled(_ enabled: Bool) {
        connectivityManager.sendValue([DefaultItem.hapticsEnabled.rawValue: enabled])
    }
}
