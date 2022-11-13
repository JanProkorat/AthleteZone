//
//  ViewRouter.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

class ViewRouter: ObservableObject {
   
    @Published var currentTab: Tab = .home
    
    init(currentTab: Tab) {
        self.currentTab = currentTab
    }
    
    init() {
        self.currentTab = .home

    }

}
