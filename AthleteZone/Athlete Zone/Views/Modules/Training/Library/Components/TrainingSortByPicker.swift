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
            ForEach(TrainingSortByProperty.allCases) { property in
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
