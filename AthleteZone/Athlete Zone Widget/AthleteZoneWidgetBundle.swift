//
//  AthleteZoneWidgetsBundle.swift
//  AthleteZoneWidgets
//
//  Created by Jan Prokorát on 28.09.2023.
//

import WidgetKit
import SwiftUI

@main
struct AthleteZoneWidgetBundle: WidgetBundle {
    var body: some Widget {
        AthleteZoneWidget()
        AthleteZoneWidgetLiveActivity()
    }
}
