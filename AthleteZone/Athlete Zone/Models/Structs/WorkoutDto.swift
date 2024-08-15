//
//  WorkOutDto.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 28.09.2023.
//

import Foundation

struct WorkoutDto: Codable, Identifiable, Equatable {
    static func == (lhs: WorkoutDto, rhs: WorkoutDto) -> Bool {
        lhs.id == rhs.id
    }

    var id: UUID

    var name: String
    var work: Int
    var rest: Int
    var series: Int
    var rounds: Int
    var reset: Int
    var createdDate: Date
    var workoutLength: Int

    init(
        id: UUID,
        name: String,
        work: Int,
        rest: Int,
        series: Int,
        rounds: Int,
        reset: Int,
        createdDate: Date,
        workoutLength: Int
    ) {
        self.id = id
        self.name = name
        self.work = work
        self.rest = rest
        self.series = series
        self.rounds = rounds
        self.reset = reset
        self.createdDate = createdDate
        self.workoutLength = workoutLength
    }
}

extension WorkoutDto {
    func encode() -> String? {
        do {
            let encodedData = try JSONEncoder().encode(self)
            let jsonString = String(data: encodedData, encoding: .utf8)
            return jsonString
        } catch {
            print(error)
            return nil
        }
    }

    func toWorkflow() -> [WorkFlow] {
        var flow: [WorkFlow] = []
        flow.append(WorkFlow(interval: Constants.PreparationTickInterval, type: .preparation,
                             round: 1, serie: 1,
                             totalSeries: series, totalRounds: rounds))
        var serieCount = 1
        var interval = 0
        for round in 1 ... rounds {
            for serie in 1 ... 2 * series {
                interval = serie.isOdd() ? work : rest
                if interval != 0 {
                    flow.append(
                        WorkFlow(
                            interval: TimeInterval(interval - 1),
                            type: serie.isOdd() ? .work : .rest,
                            round: round,
                            serie: serieCount,
                            totalSeries: series,
                            totalRounds: rounds
                        )
                    )
                }
                if serie.isEven() {
                    serieCount += 1
                }
            }
            if round < rounds {
                flow.append(
                    WorkFlow(
                        interval: TimeInterval(reset),
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
}
