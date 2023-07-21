//
//  Array.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 19.12.2022.
//

import Foundation

extension Array where Element: Encodable {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

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
