//
//  TimerRealmManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 18.03.2024.
//

import ComposableArchitecture
import Foundation
import RealmSwift

class TimerRealmManager: RealmManager, TimerRealmProtocol {
    static let shared = TimerRealmManager()
    @ObservedResults(TimerActivity.self) var timerLibrary

    func load() -> [TimerDto] {
        return Array(timerLibrary.sorted(by: \.createdDate, ascending: false)).map { $0.toDto() }
    }

    func add(interval: TimeInterval) {
        $timerLibrary.append(TimerActivity(interval: interval))

        if timerLibrary.count > 5 {
            $timerLibrary.remove(timerLibrary.sorted(by: \.createdDate, ascending: true).first!)
        }
    }
}

extension TimerRealmManager: DependencyKey {
    static var liveValue: any TimerRealmProtocol = TimerRealmManager.shared
}
