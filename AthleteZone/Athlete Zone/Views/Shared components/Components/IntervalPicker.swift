//
//  ActivityPicker.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 09.11.2022.
//

import SwiftUI

struct IntervalPicker: View {
    @Binding var type: ActivityType?
    @Binding var interval: Int

    var body: some View {
        DetailBaseView(title: LocalizedStringKey(type?.rawValue ?? ""), color: getColor()) {
            if let activityType = type {
                VStack {
                    switch activityType {
                    case .work:
                        TimePicker(textColor: ComponentColor.lightPink, interval: $interval)

                    case .rest:
                        TimePicker(textColor: ComponentColor.lightYellow, interval: $interval)

                    case .series:
                        NumberPicker(textColor: ComponentColor.lightBlue, value: $interval)

                    case .rounds:
                        NumberPicker(textColor: ComponentColor.lightGreen, value: $interval)

                    case .reset:
                        TimePicker(textColor: ComponentColor.braun, interval: $interval)
                    }
                }
                .padding(.bottom)
            }
        }
        .onCloseTab { type = nil }
    }

    private func getColor() -> ComponentColor {
        if type == nil {
            return .darkBlue
        }

        switch type! {
        case .work:
            return .lightPink

        case .rest:
            return .lightYellow

        case .series:
            return .lightBlue

        case .rounds:
            return .lightGreen

        case .reset:
            return .braun
        }
    }
}

struct ActivityPicker_Previews: PreviewProvider {
    static var previews: some View {
        IntervalPicker(type: Binding.constant(.work), interval: Binding.constant(10))
    }
}
