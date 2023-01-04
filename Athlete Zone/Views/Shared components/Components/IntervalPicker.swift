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
        self.picker = picker()
        self.title = title
        self.color = color
        self.backgroundColor = backgroundColor
    }

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(ComponentColor.darkBlue.rawValue), lineWidth: 3)
                    .foregroundColor(Color(backgroundColor.rawValue))
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(backgroundColor.rawValue))
                Text(title)
                    .font(.system(size: 40))
                    .foregroundColor(Color(color.rawValue))
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(.top, 30)
            .padding([.leading, .trailing], 10)
            .frame(maxHeight: 80)

            picker
                .frame(maxHeight: .infinity)
                .padding(.top, 20)
        }
        .frame(maxHeight: .infinity)
        .background(Color(Background.background.rawValue))
        .presentationDetents([.medium])
    }
}

struct ActivityPicker_Previews: PreviewProvider {
    static var previews: some View {
        IntervalPicker(title: "Work", color: ComponentColor.work, backgroundColor: Background.work) {
            TimePicker(textColor: ComponentColor.work.rawValue, interval: 40)
        }
    }
}
