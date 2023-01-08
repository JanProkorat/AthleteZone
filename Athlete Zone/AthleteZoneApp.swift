//
//  Athlete_ZoneApp.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.11.2022.
//

import SwiftUI

@main
struct AthleteZoneApp: App {
    @StateObject var router = ViewRouter()
    @AppStorage(DefaultItem.language.rawValue) private var language: Language = .en
    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentScene(router: router)
                .environment(\.locale, .init(identifier: "\(language)"))
                .environment(\.colorScheme, .dark)
        }
    }
}
