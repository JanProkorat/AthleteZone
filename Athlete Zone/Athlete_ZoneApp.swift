//
//  Athlete_ZoneApp.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.11.2022.
//

import SwiftUI

@main
struct Athlete_ZoneApp: App {
    
    @StateObject var router: ViewRouter = ViewRouter()
    @AppStorage("language") private var language: Language = .en

    var body: some Scene {
        WindowGroup {
            ContentScene(router: router)
                .environment(\.locale, .init(identifier: "\(language)"))
        }
    }
}
