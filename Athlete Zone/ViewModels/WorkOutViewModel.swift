//
//  WorkOutViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 13.11.2022.
//

import Foundation
import RealmSwift

class WorkOutViewModel: ObservableObject {
    @Published var selectedWorkOut = WorkOut(name: "Title", work: 40, rest: 60, series: 3, rounds: 2, reset: 60)
    @Published var workOutToEdit = WorkOut()
    @Published var workOutLibrary: Results<WorkOut>?

    let realmManager = RealmManager()

    var isEditing = false

    func setWorkOutToEdit(_ workout: WorkOut) {
        workOutToEdit = workout
    }

    func setSelectedWorkOut(_ workout: WorkOut) {
        selectedWorkOut = workout
    }

    func saveWorkOut() {
        realmManager.create(workOutToEdit, type: WorkOut.self)
    }

    func load() -> Results<WorkOut> {
        return realmManager.load(entity: WorkOut.self)
    }

    func load(entityKey: ObjectId) -> WorkOut? {
        let object = realmManager.load(entity: WorkOut.self, primaryKey: entityKey)
        return object != nil ? object : nil
    }

    func delete(_ entity: WorkOut) {
        realmManager.delete(entity: entity)
    }

    func setIsEditing(_ isEditing: Bool) {
        self.isEditing = isEditing
    }

//    func delete(entityKey: ObjectId){
//        if let index = workOutLibrary.firstIndex(where: {$0._id == entityKey}) {
//            workOutLibrary.remove(at: index)
//            realmManager.delete(entity: WorkOut.self, entityKey: entityKey)
//        }
//    }

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
