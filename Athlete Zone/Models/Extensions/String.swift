//
//  String.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 21.02.2023.
//

import Foundation

extension String {
    func decode<T: Decodable>() throws -> T {
        guard let data = data(using: .utf8) else {
            throw NSError(domain: "Error decoding string", code: 0, userInfo: nil)
        }
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch {
            throw NSError(domain: "Error decoding string", code: 0, userInfo: nil)
        }
    }
}
