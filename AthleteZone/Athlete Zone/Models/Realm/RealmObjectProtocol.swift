//
//  RealmObjectProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.12.2023.
//

import Foundation
import RealmSwift

protocol RealmObjectProtocol: Object, Identifiable {
    var _id: ObjectId { get set }
    var name: String { get set }
}
