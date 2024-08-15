//
//  NotificationManagerMock.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 14.11.2023.
//

@testable import Athlete_Zone
import Foundation

class NotificationManagerMock {
    func allowNotifications() {
        enabled = true
    }

    func setupNotification() {}

    func removeNotification() {
        enabled = false
    }

    var enabled: Bool = false
}
