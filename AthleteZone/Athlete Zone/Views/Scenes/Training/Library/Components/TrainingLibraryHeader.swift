//
//  TrainingLibraryHeader.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.07.2023.
//

import SwiftUI

struct TrainingLibraryHeader: View {
    var onAddTab: (() -> Void)?

    var body: some View {
        HStack(alignment: .center) {
            HStack(alignment: .center) {
                SectionSwitch()
                TitleText(text: "Library")
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                self.performAction(onAddTab)
            } label: {
                Image(Icons.add.rawValue)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(ComponentColor.mainText.rawValue))
                    .frame(maxHeight: 50)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct TrainingLibraryHeader_Previews: PreviewProvider {
    static var previews: some View {
        TrainingLibraryHeader()
    }
}

extension TrainingLibraryHeader {
    func onAddTab(action: @escaping (() -> Void)) -> TrainingLibraryHeader {
        var new = self
        new.onAddTab = action
        return new
    }
}
