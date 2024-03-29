//
//  EditField.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 16.11.2022.
//

import SwiftUI

struct EditField<Content: View>: View {
    let content: Content
    let label: LocalizationKey?
    let labelSize: CGFloat
    let color: ComponentColor

    init(label: LocalizationKey, labelSize: CGFloat, color: ComponentColor, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.label = label
        self.labelSize = labelSize
        self.color = color
    }

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.label = nil
        self.labelSize = 0
        self.color = ComponentColor.mainText
    }

    var onTab: (() -> Void)?

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            if label != nil {
                Text(label?.localizedKey ?? "")
                    .font(.custom("Lato-Black", size: labelSize))
                    .bold()
                    .foregroundColor(Color(color.rawValue))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 25)
            }

            content
        }
    }
}

struct EditField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EditField(label: LocalizationKey.name, labelSize: 30, color: ComponentColor.mainText) {
                Text("test")
            }
        }
    }
}

extension EditField {
    func onTab(_ handler: @escaping () -> Void) -> EditField {
        var new = self
        new.onTab = handler
        return new
    }
}
