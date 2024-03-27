//
//  RealmManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import Foundation
import RealmSwift

class RealmManager: ObservableObject {
    private(set) var realm: Realm!

    init() {
        let config = Realm.Configuration(schemaVersion: 16)
        Realm.Configuration.defaultConfiguration = config
        do {
            self.realm = try Realm()
        } catch {
            print(error.localizedDescription)
        }
    }
}
