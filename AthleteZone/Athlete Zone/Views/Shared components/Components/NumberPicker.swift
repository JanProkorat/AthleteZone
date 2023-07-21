//
//  NumberPicker.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 09.11.2022.
//

import SwiftUI

struct NumberPicker: View {
    let textColor: ComponentColor

    @Binding var value: Int

    private var numbers = Array(0 ... 50)

    init(textColor: ComponentColor, value: Binding<Int>) {
        self.textColor = textColor
        self._value = value
    }

    var body: some View {
        VStack(alignment: .center) {
            Picker(selection: $value, label: Text("Number")) {
                ForEach((1 ..< self.numbers.count).reversed(), id: \.self) {
                    Text("\(self.numbers[$0])")
                        .foregroundColor(Color(textColor.rawValue))
                        .font(.custom("Lato-Black", size: 30))
                }
            }
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(ComponentColor.menu.rawValue), lineWidth: 3)
                        .foregroundColor(Color(Background.work.rawValue))
                }
            )
            .pickerStyle(InlinePickerStyle())

            Spacer()
        }
        .padding([.top], 25)
        .padding([.leading, .trailing], 10)
    }
}

struct NumberPicker_Previews: PreviewProvider {
    static var previews: some View {
        let bind = Binding.constant(25)
        NumberPicker(textColor: ComponentColor.rounds, value: bind)
    }
}
