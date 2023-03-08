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
        let config = Realm.Configuration(schemaVersion: 6)
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
                realm.add(value, update: .modified)
            }
        } catch {
            print(error.localizedDescription)
        }
    }

    public func load<T: Object>(entity: T.Type, primaryKey: String) -> T? {
        do {
            let objectId = try ObjectId(string: primaryKey)
            return realm.object(ofType: T.self, forPrimaryKey: objectId)

        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    func load<T: Object>(entity: T.Type) -> [T] {
        var objects: [T] = []
        let queue = DispatchQueue(label: "realmQueue", qos: .background)
        queue.sync {
            do {
                let realm = try Realm()
                objects = Array(realm.objects(entity.self))
            } catch {
                print(error.localizedDescription)
            }
        }
        return objects
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

    func update(_ id: String, _ name: String, _ work: Int, _ rest: Int, _ series: Int, _ rounds: Int, _ reset: Int) -> WorkOut? {
        var result: WorkOut?
        do {
            let objectId = try ObjectId(string: id)
            try realm.write {
                let workout = realm.objects(WorkOut.self).first { $0._id == objectId }
                workout?.name = name
                workout?.work = work
                workout?.rest = rest
                workout?.series = series
                workout?.rounds = rounds
                workout?.reset = reset
                result = workout
            }
        } catch {
            print(error.localizedDescription)
            return nil
        }
        return result
    }
}
