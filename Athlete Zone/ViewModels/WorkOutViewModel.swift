//
//  WorkOutViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 13.11.2022.
//

import Foundation
import RealmSwift

class WorkOutViewModel: ObservableObject {
    @Published var selectedWorkOut: WorkOut = WorkOut(name: "Title", work: 40, rest: 60, series: 3, rounds: 2, reset: 60)
    @Published var workOutToEdit: WorkOut = WorkOut()
    @Published var workOutLibrary: [WorkOut] = [WorkOut]()
    @Published var tmo: [WorkOut] = [WorkOut(), WorkOut(), WorkOut(), WorkOut(), WorkOut()]

    let realmManager = RealmManager()
    
    func setWorkOutToEdit(_ workout: WorkOut) {
        workOutToEdit = workout
    }
    
    func setSelectedWorkOut(_ workout: WorkOut) {
        selectedWorkOut = workout
    }
    
    
    
    func saveWorkOut() -> WorkOut{
        let objectToSave = workOutToEdit.managedObject()
        realmManager.add(objectToSave, update: workOutToEdit.id != nil)
        return WorkOut(managedObject: objectToSave)
    }
    
    func load() -> [WorkOut] {
        let objects = realmManager.load(entity: WorkOutObject.self)
        var result = [WorkOut]()
        for object in objects{
            result.append(WorkOut(managedObject: object))
        }
        return result
    }
    
    func load(entityKey: ObjectId) -> WorkOut? {
        let object = realmManager.load(entity: WorkOutObject.self, primaryKey: entityKey)
        return object != nil ? WorkOut(managedObject: object!) : nil
    }
    
    func delete(_ entity: WorkOut){
        realmManager.delete(entity: entity.managedObject())
    }
    func delete(entityKey: ObjectId){
        if let index = workOutLibrary.firstIndex(where: {$0._id == entityKey}) {
            workOutLibrary.remove(at: index)
            realmManager.delete(entity: WorkOutObject.self, entityKey: entityKey)
        }
    }
    
}
