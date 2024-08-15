//
//  String.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 21.02.2023.
//

import Foundation

extension String {
    func decode<T: Decodable>() -> T? {
        guard let data = data(using: .utf8) else {
            print("Error decoding string")
            return nil
        }
        do {
            let decoder = JSONDecoder()
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch {
            print("Error decoding string")
            return nil
        }
    }

    func toPascalCase() -> String {
        let input = lowercased()
        let words = input.components(separatedBy: CharacterSet.alphanumerics.inverted)
        let capitalizedWords = words.map { $0.capitalized }
        let joinedWords = capitalizedWords.joined()
        return joinedWords.prefix(1).lowercased() + joinedWords.dropFirst()
    }
}
