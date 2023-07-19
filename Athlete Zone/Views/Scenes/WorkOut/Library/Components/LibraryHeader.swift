//
//  LibraryHeader.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct LibraryHeader: View {
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

struct LibraryHeader_Previews: PreviewProvider {
    static var previews: some View {
        LibraryHeader()
    }
}

extension LibraryHeader {
    func onAddTab(action: @escaping (() -> Void)) -> LibraryHeader {
        var new = self
        new.onAddTab = action
        return new
    }
}
