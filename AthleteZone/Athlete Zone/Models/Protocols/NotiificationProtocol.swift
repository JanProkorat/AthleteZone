//
//  NotiificationProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 14.11.2023.
//

import Foundation

protocol NotiificationProtocol {
    func allowNotifications()
    func setupNotification()
    func removeNotification()

    var enabled: Bool { get set }
}
