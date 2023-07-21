//
//  EditSection.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 16.07.2023.
//

import SwiftUI

struct EditSection<Content: View>: View {
    var icon: String
    var label: String
    var color: ComponentColor
    var content: Content
    var disabled: Bool

    init(
        icon: String,
        label: String,
        color: ComponentColor,
        disabled: Bool = false,
        @ViewBuilder content: () -> Content
    ) {
        self.icon = icon
        self.label = label
        self.color = color
        self.disabled = disabled
        self.content = content()
    }

    var body: some View {
        Collapsible(disabled: disabled) {
            Image(systemName: icon)
                .resizable()
                .scaledToFill()
                .foregroundColor(Color(color.rawValue))
                .frame(maxWidth: 35, maxHeight: 35)
                .padding(.top, 5)

            Text(LocalizedStringKey(label))
                .font(.title)
                .padding(.leading, 5)
                .foregroundColor(Color(color.rawValue))
        } content: {
            content
        }
        .padding([.leading, .trailing], 5)
        .roundedBackground(cornerRadius: 20)
    }
}

struct EditSection_Previews: PreviewProvider {
    static var previews: some View {
        EditSection(icon: "pencil.circle", label: "Name", color: ComponentColor.work) {
            EditField {
                TextInput(text: Binding.constant("Name"))
            }
        }
    }
}
