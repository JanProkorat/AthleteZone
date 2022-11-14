//
//  WorkOut.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 10.11.2022.
//

import Foundation

struct WorkOut {
    var id: Int = 0
    
    var name: String = "Title"
    var work: Int = 30  // Time in num of secs
    var rest: Int = 60  // Time in num of secs
    var series: Int = 6
    var rounds: Int = 1
    var reset: Int = 60  // Time in num of secs
    
    var timeOverview: Int {
        return ((work * series) + (rest * (series - 1)) + reset) * rounds
    }
    
    mutating func setName(_ name: String) {
        self.name = name
    }
    
    mutating func setWork(_ work: Int) {
        self.work = work
    }
    
    mutating func setRest(_ rest: Int) {
        self.rest = rest
    }
    
    mutating func setSeries(_ series: Int) {
        self.series = series
    }
    
    mutating func setRounds(_ rounds: Int) {
        self.rounds = rounds
    }
    
    mutating func setReset(_ reset: Int) {
        self.reset = reset
    }
    
    
}
