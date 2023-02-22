//
//  WorkOut.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 10.11.2022.
//

import Foundation
import RealmSwift

public class WorkOut: Object, Identifiable, Codable {
    @Persisted(primaryKey: true) var _id: ObjectId

    @objc @Persisted var name: String
    @objc @Persisted var work: Int
    @objc @Persisted var rest: Int
    @objc @Persisted var series: Int
    @objc @Persisted var rounds: Int
    @objc @Persisted var reset: Int
    @objc @Persisted var createdDate: Date

    override init() {
        name = "Title"
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

    @objc var timeOverview: Int {
        (((work * series) + (rest * (series - 1)) + reset) * rounds) - reset
    }

    @objc var formattedCreatedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: createdDate)
    }

    func setName(_ name: String) {
        self.name = name
    }

    func setWork(_ work: Int) {
        self.work = work
    }

    func setRest(_ rest: Int) {
        self.rest = rest
    }

    func setSeries(_ series: Int) {
        self.series = series
    }

    func setRounds(_ rounds: Int) {
        self.rounds = rounds
    }

    func setReset(_ reset: Int) {
        self.reset = reset
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

    func encode() -> String {
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
