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
            ForEach(StopWatchSortByProperty.allCases.sorted { $0.rawValue < $1.rawValue }) { property in
                Button(action: {
                    selectedProperty = property
                }, label: {
                    Label(LocalizedStringKey(property.rawValue),
                          systemImage: selectedProperty == property ? "checkmark" : "")
                })
            }

        } label: {
            RoundedRectangle(cornerRadius: 20)
                .overlay(
                    HStack(alignment: .center, spacing: 1) {
                        Text(LocalizationKey.sortBy.localizedKey)
                            .padding(.leading, 5)
                            .foregroundColor(Color(ComponentColor.darkBlue.rawValue))
                    }
                )
                .foregroundColor(Color(ComponentColor.menuItemSelected.rawValue))
                .frame(width: .infinity,
                       height: 40,
                       alignment: .center)
                .cornerRadius(35)
        }
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
