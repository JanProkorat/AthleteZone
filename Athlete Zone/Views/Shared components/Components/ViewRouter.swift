//
//  ViewRouter.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

class ViewRouter: ObservableObject {
   
    @Published var currentTab: Tab = .home
    @Published var activeHomeSheet: ActivitySheet?
    @Published var activeEditSheet: ActivitySheet?

    init(currentTab: Tab) {
        self.currentTab = currentTab
    }
    
    init() {
        self.currentTab = .home

    }
    
    func setActiveHomeSheet(_ sheet: ActivitySheet){
        self.activeHomeSheet = sheet
    }
    
    func setActiveEditSheet(_ sheet: ActivitySheet){
        self.activeEditSheet = sheet
    }
    

}
