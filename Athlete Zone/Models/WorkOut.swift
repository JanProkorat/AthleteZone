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
    var work: Int = 5  // Time in num of secs
    var rest: Int = 5  // Time in num of secs
    var series: Int = 2
    var rounds: Int = 2
    var reset: Int = 5  // Time in num of secs
    
    init(){
    }
    
    init(name: String, work: Int, rest: Int, series: Int, rounds: Int, reset: Int) {
        self.name = name
        self.work = work
        self.rest = rest
        self.series = series
        self.rounds = rounds
        self.reset = reset
    }
    
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
