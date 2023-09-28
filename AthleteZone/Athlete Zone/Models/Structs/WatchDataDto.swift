//
//  WatchDataDto.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 25.08.2023.
//

import Foundation

struct WatchDataDto: Codable {
    var workouts: [WorkOut]
    var trainings: [Training]
}

extension WatchDataDto {
    func toJSONString() -> String? {
        let encoder = JSONEncoder()
        do {
            let jsonData = try encoder.encode(self)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                throw NSError(domain: "Error converting JSON data to string", code: 0, userInfo: nil)
            }
            return jsonString
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
