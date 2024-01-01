//
//  TrainingHeader.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 24.03.2023.
//

import SwiftUI

struct TrainingHeader: View {
    var name: String?
    var onAddTab: (() -> Void)?

    var body: some View {
        HStack {
            HStack(alignment: .center) {
                SectionSwitch()
                if let name = self.name {
                    TitleText(text: name)
                } else {
                    TitleText(text: LocalizationKey.training.rawValue)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                performAction(self.onAddTab)
            } label: {
                if name != nil {
                    HStack {
                        Image(systemName: "pencil")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color(ComponentColor.mainText.rawValue))
                            .frame(maxHeight: 20)
                            .padding(10)
                    }
                    .roundedBackground(cornerRadius: 10, color: .darkBlue, border: ComponentColor.mainText, borderWidth: 3)
                    .padding(.trailing, 5)
                }
            }
        }
    }
}

struct TrainingHeader_Previews: PreviewProvider {
    static var previews: some View {
        TrainingHeader(name: "Test training")
    }
}

extension TrainingHeader {
    func onAddTab(action: @escaping () -> Void) -> TrainingHeader {
        var new = self
        new.onAddTab = action
        return new
    }
}
