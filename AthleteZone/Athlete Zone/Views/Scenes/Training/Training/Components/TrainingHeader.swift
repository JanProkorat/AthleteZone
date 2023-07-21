//
//  TrainingHeader.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 24.03.2023.
//

import SwiftUI

struct TrainingHeader: View {
    var name: String?
    var onSaveTab: (() -> Void)?

    var body: some View {
        HStack {
            HStack(alignment: .center) {
                SectionSwitch()
                TitleText(text: name ?? "Training")
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                performAction(self.onSaveTab)
            } label: {
                if name != nil {
                    Image(Icons.save.rawValue)
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(Color(ComponentColor.mainText.rawValue))
                        .frame(maxHeight: 50)
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
    func onSaveTab(action: @escaping () -> Void) -> TrainingHeader {
        var new = self
        new.onSaveTab = action
        return new
    }
}
