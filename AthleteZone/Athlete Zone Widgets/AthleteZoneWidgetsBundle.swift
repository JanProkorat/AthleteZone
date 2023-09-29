//
//  AthleteZoneWidgetsBundle.swift
//  AthleteZoneWidgets
//
//  Created by Jan Prokorát on 28.09.2023.
//

import WidgetKit
import SwiftUI

@main
struct AthleteZoneWidgetsBundle: WidgetBundle {
    var body: some Widget {
        AthleteZoneWidgets()
        AthleteZoneWidgetsLiveActivity()
    }
}
