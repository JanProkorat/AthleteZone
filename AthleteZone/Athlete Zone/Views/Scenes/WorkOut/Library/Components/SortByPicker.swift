//
//  SortByPicker.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 29.12.2022.
//

import SwiftUI

struct SortByPicker: View {
    @State var selectedProperty = WorkOutSortByProperty.name

    var onPropertySelected: ((_ value: WorkOutSortByProperty) -> Void)?

    var body: some View {
        Menu {
            ForEach(WorkOutSortByProperty.allCases.sorted { $0.rawValue < $1.rawValue }) { property in
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
                        Text("Sort by")
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

struct SortByPicker_Previews: PreviewProvider {
    static var previews: some View {
        SortByPicker()
    }
}

extension SortByPicker {
    func onPropertySelected(_ handler: @escaping (_ value: WorkOutSortByProperty) -> Void) -> SortByPicker {
        var new = self
        new.onPropertySelected = handler
        return new
    }
}
