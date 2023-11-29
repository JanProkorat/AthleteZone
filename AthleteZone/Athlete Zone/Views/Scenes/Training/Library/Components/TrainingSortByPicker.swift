//
//  SortByPicker.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.07.2023.
//

import SwiftUI

struct TrainingSortByPicker: View {
    @State var selectedProperty = TrainingSortByProperty.name

    var onPropertySelected: ((_ value: TrainingSortByProperty) -> Void)?

    var body: some View {
        Menu {
            ForEach(TrainingSortByProperty.allCases.sorted { $0.rawValue < $1.rawValue }) { property in
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

struct TrainingSortByPicker_Previews: PreviewProvider {
    static var previews: some View {
        SortByPicker()
    }
}

extension TrainingSortByPicker {
    func onPropertySelected(_ handler: @escaping (_ value: TrainingSortByProperty) -> Void) -> TrainingSortByPicker {
        var new = self
        new.onPropertySelected = handler
        return new
    }
}
