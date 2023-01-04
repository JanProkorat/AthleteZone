//
//  ExerciseHeaderView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 07.11.2022.
//

import SwiftUI

struct WorkOutHeader: View {
    var onSectionChangeTab: (() -> Void)?
    var onSaveTab: (() -> Void)?

    let name: String

    init(_ name: String) {
        self.name = name
    }

    var body: some View {
        HStack {
            HStack(alignment: .center) {
//                Image(Icons.ArrowDown)
//                    .resizable()
//                    .scaledToFill()
//                    .foregroundColor(Color(ComponentColor.mainText.rawValue))
//                    .frame(maxWidth: 55, maxHeight: 50)

                TitleText(text: name)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                performAction(self.onSaveTab)
            } label: {
                Image(Icons.Save)
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(Color(ComponentColor.mainText.rawValue))
                    .frame(maxHeight: 50)
            }
        }
    }
}

struct ExerciseHeaderBar_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutHeader("Title")
            .environmentObject(WorkOutViewModel())
    }
}

extension WorkOutHeader {
    func onSectionChangeTab(action: @escaping (() -> Void)) -> WorkOutHeader {
        var new = self
        new.onSectionChangeTab = action
        return new
    }

    func onSaveTab(action: @escaping (() -> Void)) -> WorkOutHeader {
        var new = self
        new.onSaveTab = action
        return new
    }
}
