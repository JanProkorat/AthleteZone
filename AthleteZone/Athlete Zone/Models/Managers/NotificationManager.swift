//
//  NotificationManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.02.2023.
//

import Combine
import ComposableArchitecture
import Foundation
import UserNotifications

class NotificationProvider {
    static var shared = NotificationProvider()

    let notificationIdentifier1 = "workoutReminder1"
    let notificationIdentifier2 = "workoutReminder2"
    let messages = [
        LocalizationKey.notification1,
        LocalizationKey.notification2,
        LocalizationKey.notification3,
        LocalizationKey.notification4
    ]

    func allowNotifications() {
        let content = UNMutableNotificationContent()
        content.title = NSLocalizedString(LocalizationKey.appTitle.rawValue, comment: "")
        content.body = NSLocalizedString(messages.randomElement()?.rawValue ?? "", comment: "")
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 9
        let trigger1 = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        dateComponents.hour = 16
        let trigger2 = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request1 = UNNotificationRequest(identifier: notificationIdentifier1, content: content, trigger: trigger1)
        let request2 = UNNotificationRequest(identifier: notificationIdentifier2, content: content, trigger: trigger2)

        UNUserNotificationCenter.current().add(request1)
        UNUserNotificationCenter.current().add(request2)
    }

    func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { _, error in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func removeNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier1])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier2])
    }
}

struct NotificationManager {
    var allowNotifications: @Sendable () -> Void
    var removeNotification: @Sendable () -> Void
    var requestAuthorization: @Sendable () -> Void
}

extension NotificationManager: DependencyKey {
    static var liveValue = Self(
        allowNotifications: {
            NotificationProvider.shared.allowNotifications()
        },
        removeNotification: {
            NotificationProvider.shared.removeNotification()
        },
        requestAuthorization: {
            NotificationProvider.shared.requestAuthorization()
        }
    )
    static var testValue = Self(
        allowNotifications: {},
        removeNotification: {},
        requestAuthorization: {}
    )
}
