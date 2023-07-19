//
//  WorkOut.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 10.11.2022.
//

import Foundation
import RealmSwift

@objcMembers
public class WorkOut: Object, Identifiable, Codable {
    @Persisted(primaryKey: true) var _id: ObjectId

    @Persisted var name: String
    @Persisted var work: Int
    @Persisted var rest: Int
    @Persisted var series: Int
    @Persisted var rounds: Int
    @Persisted var reset: Int
    @Persisted var createdDate: Date

    var workFlow: [WorkFlow] {
        var flow: [WorkFlow] = []
        flow.append(WorkFlow(interval: 10, type: .preparation,
                             round: 1, serie: 1,
                             totalSeries: series, totalRounds: rounds))
        var serieCount = 1
        var interval = 0
        for round in 1 ... rounds {
            for serie in 1 ... (series + (series - 1)) {
                interval = serie.isOdd() ? work : rest
                if interval != 0 {
                    flow.append(
                        WorkFlow(
                            interval: interval - 1,
                            type: serie.isOdd() ? .work : .rest,
                            round: round,
                            serie: serieCount,
                            totalSeries: series,
                            totalRounds: rounds
                        )
                    )
                }
                if serie.isIven() {
                    serieCount += 1
                }
            }
            if round < rounds {
                flow.append(
                    WorkFlow(
                        interval: reset,
                        type: .reset,
                        round: round,
                        serie: flow[flow.count - 1].serie,
                        totalSeries: series,
                        totalRounds: rounds
                    )
                )
                serieCount = 1
            }
        }

        return flow
    }

    override init() {
        name = ""
        work = 30
        rest = 60
        series = 3
        rounds = 2
        reset = 60
        createdDate = Date()
    }

    init(_ name: String, _ work: Int, _ rest: Int, _ series: Int, _ rounds: Int, _ reset: Int) {
        self.name = name
        self.work = work
        self.rest = rest
        self.series = series
        self.rounds = rounds
        self.reset = reset
        createdDate = Date()
    }

    init(_ id: String, _ name: String, _ work: Int, _ rest: Int, _ series: Int, _ rounds: Int, _ reset: Int) {
        super.init()
        self.name = name
        self.work = work
        self.rest = rest
        self.series = series
        self.rounds = rounds
        self.reset = reset

        do {
            _id = try ObjectId(string: id)
        } catch {
            print(error.localizedDescription)
        }
    }

    var workoutLength: Int {
        (((work * series) + (rest * (series - 1)) + reset) * rounds) - reset
    }

    var formattedCreatedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: createdDate)
    }

    override public static func ignoredProperties() -> [String] {
        return ["objectWillChange"]
    }

    enum CodingKeys: String, CodingKey {
        case name, work, rest, series, rounds, reset, createdDate, _id
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(work, forKey: .work)
        try container.encode(rest, forKey: .rest)
        try container.encode(series, forKey: .series)
        try container.encode(rounds, forKey: .rounds)
        try container.encode(reset, forKey: .reset)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(_id, forKey: ._id)
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
