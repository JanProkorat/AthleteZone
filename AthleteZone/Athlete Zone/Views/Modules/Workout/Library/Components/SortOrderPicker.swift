//
//  ListViewConfigButton.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 27.12.2022.
//

import SwiftUI

struct SortOrderPicker: View {
    @State var selectedOrder = SortOrder.ascending

    var onOrderSelected: ((_ value: SortOrder) -> Void)?

    var body: some View {
        Menu {
            ForEach(SortOrder.allCases) { order in
                Button(action: {
                    selectedOrder = order
                }, label: {
                    Label(LocalizedStringKey(order.rawValue), systemImage: selectedOrder == order ? "checkmark" : "")
                })
            }

        } label: {
            Text(LocalizationKey.sortOrder.localizedKey)
                .padding(.leading, 5)
                .foregroundColor(Color(ComponentColor.darkBlue.rawValue))
                .frame(maxWidth: .infinity)
                .padding([.top, .bottom], 10)
        }
        .roundedBackground(cornerRadius: 35, color: ComponentColor.action)
        .onChange(of: selectedOrder) { _, newValue in
            performAction(onOrderSelected, value: newValue)
        }
    }
}

struct ListViewConfigButton_Previews: PreviewProvider {
    static var previews: some View {
        SortOrderPicker()
    }
}

extension SortOrderPicker {
    func onOrderSelected(_ handler: @escaping (_ value: SortOrder) -> Void) -> SortOrderPicker {
        var new = self
        new.onOrderSelected = handler
        return new
    }
}
