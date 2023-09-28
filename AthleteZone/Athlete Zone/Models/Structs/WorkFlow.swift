//
//  WorkFlow.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import Foundation

struct WorkFlow: Equatable, Codable, Hashable {
    var interval: Int
    let type: WorkFlowType
    let round: Int
    let serie: Int
    let originalInterval: Int
    let totalSeries: Int
    let totalRounds: Int
    var color: ComponentColor

    var lastRound: Bool {
        round == totalRounds
    }

    var lastSerie: Bool {
        serie == totalSeries
    }

    init() {
        self.interval = 0
        self.type = .work
        self.round = 0
        self.serie = 0
        self.originalInterval = 0
        self.totalRounds = 0
        self.totalSeries = 0
        self.color = .work
    }

    init(interval: Int, type: WorkFlowType, round: Int, serie: Int, totalSeries: Int, totalRounds: Int) {
        self.interval = interval
        self.type = type
        self.round = round
        self.serie = serie
        self.originalInterval = interval
        self.totalRounds = totalRounds
        self.totalSeries = totalSeries
        self.color = .yellow
        switch type {
        case .work:
            self.color = .pink

        case .rest:
            self.color = .yellow

        default:
            self.color = .braun
        }
    }

    func getProgress() -> Double {
        return Double(originalInterval - interval) / Double(originalInterval)
    }

    public func encode() -> String {
        do {
            let encodedData = try JSONEncoder().encode(self)
            let jsonString = String(data: encodedData, encoding: .utf8)
            return jsonString ?? ""
        } catch {
            print(error)
            return ""
        }
    }
}

extension WorkFlow {
    static func decode(from data: Data?) -> WorkFlow? {
        if let unwrapped = data {
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(WorkFlow.self, from: unwrapped)
                return decodedData
            } catch {
                print(error)
                return nil
            }
        }
        return nil
    }
}
