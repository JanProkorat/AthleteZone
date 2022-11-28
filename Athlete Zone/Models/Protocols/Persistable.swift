//
//  Persistable.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 24.11.2022.
//

import RealmSwift

public protocol Persistable {
    associatedtype ManagedObject: RealmSwift.Object
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}
