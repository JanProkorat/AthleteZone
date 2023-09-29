//
//  WidgetDataManager.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 23.09.2023.
//

import Foundation

class WidgetDataManager {
    static let shared = WidgetDataManager()

    // Define the shared container directory URL
    private let sharedContainerURL: URL? = FileManager.default.containerURL(
        forSecurityApplicationGroupIdentifier: UserDefaultValues.groupId.rawValue
    )

    // Define the file URL where you want to store data
    private var dataFileURL: URL? {
        sharedContainerURL?.appendingPathComponent("widgetData.json")
    }

    func saveWidgetData(_ workoutName: String, _ data: WorkFlow?) {
        guard let dataFileURL = dataFileURL else {
            return
        }

        do {
            if data == nil {
                if FileManager.default.fileExists(atPath: dataFileURL.path()) {
                    try FileManager.default.removeItem(at: dataFileURL)
                }
                return
            }

            let encoder = JSONEncoder()
            let encodedData = try encoder.encode(WidgetDataDto(workFlow: data!, name: workoutName))
            try encodedData.write(to: dataFileURL)
        } catch {
            print("Error saving widget data: \(error)")
        }
    }

    func loadWidgetData() -> WidgetDataDto? {
        guard let dataFileURL = dataFileURL,
              let data = try? Data(contentsOf: dataFileURL)
        else {
            return nil
        }

        do {
            let decoder = JSONDecoder()
            let widgetData = try decoder.decode(WidgetDataDto.self, from: data)
            return widgetData
        } catch {
            print("Error loading widget data: \(error)")
            return nil
        }
    }
}
