//
//  WorkOut.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 10.11.2022.
//

import Foundation
import RealmSwift

struct WorkOut: Identifiable {
    var _id: ObjectId?
    var id: UInt64?
    
    var name: String
    var work: Int
    var rest: Int
    var series: Int
    var rounds: Int
    var reset: Int
    
    init(){
        self.id = nil
        self.name = "Title"
        self.work = 5
        self.rest = 5
        self.series = 1
        self.rounds = 1
        self.reset = 5
    }
    
    init(name: String, work: Int, rest: Int, series: Int, rounds: Int, reset: Int) {
        self.id = nil
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

extension WorkOut: Persistable {
    public init(managedObject: WorkOutObject) {
        _id = managedObject._id
        name = managedObject.name
        work = managedObject.work
        rest = managedObject.rest
        series = managedObject.series
        rounds = managedObject.rounds
        reset = managedObject.reset
    }
    
    public func managedObject() -> WorkOutObject {
        let workout = WorkOutObject()
        workout._id = _id ?? ObjectId()
        workout.name = name
        workout.work = work
        workout.rest = rest
        workout.series = series
        workout.rounds = rounds
        workout.reset = reset
        return workout
    }
}
