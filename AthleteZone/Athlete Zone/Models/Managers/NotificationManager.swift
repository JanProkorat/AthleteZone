//
//  NotificationManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.02.2023.
//

import Combine
import Foundation
import UserNotifications

class NotificationManager: NotiificationProtocol, ObservableObject {
    static let shared = NotificationManager()

    let notificationIdentifier1 = "workoutReminder1"
    let notificationIdentifier2 = "workoutReminder2"
    let messages = [
        "Don't forget to workout today",
        "Don't forget to crush your workout today!",
        "Time to sweat it out - your workout is waiting!",
        "Get up, get moving, get your workout in!"
    ]

    @Published var enabled = false
    private var cancellable: AnyCancellable?

    init() {
        cancellable = $enabled.sink { newValue in
            if newValue {
                self.setupNotification()
            }
        }
    }

    func allowNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                self.enabled = true
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }

    func setupNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Athlete Zone"
        content.body = NSLocalizedString(messages.randomElement() ?? "", comment: "")
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

    func removeNotification() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier1])
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [notificationIdentifier2])
        enabled = false
    }
}
