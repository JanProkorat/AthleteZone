//
//  WorkOutViewModel.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 13.11.2022.
//

import Foundation

class WorkOutViewModel: ObservableObject {
    @Published var selectedWorkOut: WorkOut = WorkOut(name: "Title", work: 40, rest: 60, series: 3, rounds: 2, reset: 60)
    @Published var workOutToEdit: WorkOut = WorkOut()

    func setWorkOutToEdit(_ workout: WorkOut) {
        workOutToEdit = workout
    }
    
}
