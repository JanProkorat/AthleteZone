//
//  RealmManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 24.11.2022.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    private(set) var realm: Realm!

    init() {
        let config = Realm.Configuration(schemaVersion: 5)
        Realm.Configuration.defaultConfiguration = config
        do {
            self.realm = try Realm()
        } catch {
            print(error.localizedDescription)
        }
    }

    public func add<T: Object>(_ value: T) {
        do {
            try realm.write {
                realm.add(value)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    public func create<T: Object>(_ value: T, type: T.Type) {
        do {
            try realm.write {
                realm.create(T.self, value: value, update: .error)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    public func load<T: Object>(entity: T.Type, primaryKey: ObjectId) -> T? {
        return realm.object(ofType: T.self, forPrimaryKey: primaryKey)
    }

    func load<T: Object>(entity: T.Type) -> Results<T> {
        return realm.objects(entity)
    }

    func delete(entity: Object) {
        do {
            try realm.write {
                realm.delete(entity)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    func delete<T: Object>(entity: T.Type, entityKey: ObjectId) {
        do {
            try realm.write {
                realm.delete(realm.object(ofType: entity.self, forPrimaryKey: entityKey)!)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
