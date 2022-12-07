//
//  NumberPicker.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 09.11.2022.
//

import SwiftUI

struct NumberPicker: View {
    let textColor: String
    var onValueChange: ((_ value: Int) -> Void)?

    @State private var selectedValue = 1

    init(textColor: String, value: Int) {
        self.textColor = textColor
        self._selectedValue = State<Int>(initialValue: value)
    }

    private var numbers = Array(0 ... 50)

    var body: some View {
        VStack(alignment: .center) {
            Picker(selection: $selectedValue, label: Text("Number")) {
                ForEach((1 ..< self.numbers.count).reversed(), id: \.self) {
                    Text("\(self.numbers[$0])")
                        .foregroundColor(Color(textColor))
                        .font(.custom("Lato-Black", size: 30))
                }
            }
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(Colors.Menu), lineWidth: 3)
                        .foregroundColor(Color(Backgrounds.WorkBackground))
                }
            )
            .pickerStyle(InlinePickerStyle())

            Spacer()
        }
        .padding([.top], 25)
        .padding([.leading, .trailing], 10)
        .onChange(of: selectedValue, perform: { _ in
            self.performAction(onValueChange, value: self.selectedValue)
        })
    }
}

struct NumberPicker_Previews: PreviewProvider {
    static var previews: some View {
        NumberPicker(textColor: Colors.Rounds, value: 5)
    }
}

extension NumberPicker {
    func onValueChange(_ handler: @escaping (_ value: Int) -> Void) -> NumberPicker {
        var new = self
        new.onValueChange = handler
        return new
    }
}
