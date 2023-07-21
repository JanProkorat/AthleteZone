//
//  ActivityPicker.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 09.11.2022.
//

import SwiftUI

struct IntervalPicker<Picker: View>: View {
    let picker: Picker
    let title: String
    let color: ComponentColor
    let backgroundColor: Background

    init(title: String, color: ComponentColor, backgroundColor: Background, @ViewBuilder picker: () -> Picker) {
        self.title = title
        self.color = color
        self.backgroundColor = backgroundColor
        self.picker = picker()
    }

    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(ComponentColor.darkBlue.rawValue), lineWidth: 3)
                    .foregroundColor(Color(backgroundColor.rawValue))
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(backgroundColor.rawValue))
                Text(LocalizedStringKey(title))
                    .font(.title)
                    .foregroundColor(Color(color.rawValue))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.top, 20)
            .padding([.leading, .trailing], 10)
            .frame(maxHeight: 80)

            picker
                .frame(maxHeight: .infinity)
        }
        .background(Color(Background.sheetBackground.rawValue))
        .environment(\.colorScheme, .dark)
    }
}

struct ActivityPicker_Previews: PreviewProvider {
    static var previews: some View {
        IntervalPicker(title: "Work", color: ComponentColor.work, backgroundColor: Background.work) {
            let bindingInt = Binding.constant(40)
            TimePicker(textColor: ComponentColor.work, interval: bindingInt)
        }
    }
}
