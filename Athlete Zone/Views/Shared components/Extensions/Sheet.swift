//
//  Sheet.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 09.11.2022.
//

import SwiftUI

extension Sheet {
  @ViewBuilder
  var modalView: some View {
    switch self {
    case .work:
        ActivityPicker(title: "Work", color: Colors.Work, backgroundColor: Backgrounds.WorkBackground, picker: AnyView(TimePicker(textColor: Colors.Work)))
    case .rest:
        ActivityPicker(title: "Rest", color: Colors.Rest, backgroundColor: Backgrounds.RestBackground, picker: AnyView(TimePicker(textColor: Colors.Rest)))
    case .rounds:
        ActivityPicker(title: "Rounds", color: Colors.Rounds, backgroundColor: Backgrounds.RoundsBackground, picker: AnyView(NumberPicker(textColor: Colors.Rounds)))
    case .series:
        ActivityPicker(title: "Series", color: Colors.Series, backgroundColor: Backgrounds.SeriesBackground, picker: AnyView(NumberPicker(textColor: Colors.Series)))
    case .reset:
        ActivityPicker(title: "Reset", color: Colors.Reset, backgroundColor: Backgrounds.ResetBackground, picker: AnyView(TimePicker(textColor: Colors.Reset)))
    case .save:
        ActivityPicker(title: "Rest", color: Colors.Rest, backgroundColor: Backgrounds.RestBackground, picker: AnyView(TimePicker(textColor: Colors.Rest)))
    case .donate:
        ActivityPicker(title: "Rest", color: Colors.Rest, backgroundColor: Backgrounds.RestBackground, picker: AnyView(TimePicker(textColor: Colors.Rest)))
    }
  }
}
