//
//  StopWatchSortByPicker.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import SwiftUI

struct StopWatchSortByPicker: View {
    @State var selectedProperty = StopWatchSortByProperty.name

    var onPropertySelected: ((_ value: StopWatchSortByProperty) -> Void)?

    var body: some View {
        Menu {
            ForEach(StopWatchSortByProperty.allCases) { property in
                Button(action: {
                    selectedProperty = property
                }, label: {
                    Label(LocalizedStringKey(property.rawValue),
                          systemImage: selectedProperty == property ? "checkmark" : "")
                })
            }

        } label: {
            Text(LocalizationKey.sortBy.localizedKey)
                .padding(.leading, 5)
                .foregroundColor(Color(ComponentColor.darkBlue.rawValue))
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 10)
        }
        .roundedBackground(cornerRadius: 35, color: ComponentColor.action)
        .onChange(of: selectedProperty) { _, newValue in
            performAction(onPropertySelected, value: newValue)
        }
    }
}

extension StopWatchSortByPicker {
    func onPropertySelected(_ handler: @escaping (_ value: StopWatchSortByProperty) -> Void) -> StopWatchSortByPicker {
        var new = self
        new.onPropertySelected = handler
        return new
    }
}

#Preview {
    StopWatchSortByPicker()
}
