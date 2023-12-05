//
//  AppStorageProtocol.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 14.11.2023.
//

import Foundation

protocol AppStorageProtocol: ObservableObject {
    var selectedWorkoutId: String { get set }
    var selectedTrainingId: String { get set }
    var selectedSection: Section { get set }
    var language: Language { get set }
    var soundsEnabled: Bool { get set }
    var hapticsEnabled: Bool { get set }
    var notificationsEnabled: Bool { get set }
    var stopWatchType: TimerType { get set }

    /// Stores data to be displayed in widget do user defaults
    /// - Parameters:
    ///   - data: DTOs in JSON format to be stored
    ///   - key: Key of the property in user defaults
    func storeToUserDefaults(data: String, key: UserDefaultValues)

    /// Retrieves stored datafor widget  in JSON format from user defaults by given key
    /// - Parameter key: Key of the property in user defaults
    /// - Returns: DTO in JSON format
    func loadFromDefaults(key: UserDefaultValues) -> String?

    /// Removes stored data from user defaults
    /// - Parameter key: Key of the property in user defaults
    func removeFromDefaults(key: UserDefaultValues)
}
