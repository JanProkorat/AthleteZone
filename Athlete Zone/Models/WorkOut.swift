//
//  WorkOut.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 10.11.2022.
//

import Foundation

class WorkOut: Identifiable, ObservableObject {
    var id: Int = 0
    
    @Published var name: String = "Title"
    @Published var work: Int = 30  // Time in num of secs
    @Published var rest: Int = 60  // Time in num of secs
    @Published var series: Int = 6
    @Published var rounds: Int = 2
    @Published var reset: Int = 60  // Time in num of secs
    
    var timeOverview: Int {
        return ((work * series) + (rest * (series - 1)) + reset) * rounds
    }
}
