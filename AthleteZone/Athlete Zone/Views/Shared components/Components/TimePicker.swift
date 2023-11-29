//
//  TimePicker.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 09.11.2022.
//

import SwiftUI

struct TimePicker: View {
    let textColor: ComponentColor
    @Binding var interval: Int

    private let hours = Array(0...23)
    private let minutes = Array(0...59)
    private let seconds = Array(0...59)

    @State var selectedHours: Int = 0
    @State var selectedMins: Int = 0
    @State var selectedSecs: Int = 0

    init(textColor: ComponentColor, interval: Binding<Int>) {
        self.textColor = textColor
        self._interval = interval
        self._selectedHours = State<Int>(initialValue: interval.wrappedValue.toHours())
        self._selectedMins = State<Int>(initialValue: interval.wrappedValue.toMinutes())
        self._selectedSecs = State<Int>(initialValue: interval.wrappedValue.toSeconds())
    }

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            HStack(alignment: .center, spacing: 5) {
                picker(selectedValue: $selectedHours, range: hours, label: "Hours")
                divider

                picker(selectedValue: $selectedMins, range: minutes, label: "Mins")
                divider

                picker(selectedValue: $selectedSecs, range: seconds, label: "Secs")
            }
            .padding([.top], 25)
            Spacer()
        }
        .padding([.leading, .trailing], 10)
    }

    @ViewBuilder
    private func picker(selectedValue: Binding<Int>, range: [Int], label: String) -> some View {
        Picker(selection: selectedValue, label: Text(label)) {
            ForEach((0 ..< range.count).reversed(), id: \.self) {
                Text("\(range[$0])")
                    .foregroundColor(Color(textColor.rawValue))
                    .font(.custom("Lato-Black", size: 30))
            }
        }
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color(ComponentColor.menu.rawValue), lineWidth: 3)
                    .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
            }
        )
        .pickerStyle(InlinePickerStyle())
        .onChange(of: selectedValue.wrappedValue) { _, _ in
            interval = selectedHours * 3600 + selectedMins * 60 + selectedSecs
        }
    }

    @ViewBuilder
    private var divider: some View {
        Text(":")
            .foregroundColor(Color(ComponentColor.lightPink.rawValue))
            .font(.custom("Lato-Black", size: 60))
    }
}

struct TimePicker_Previews: PreviewProvider {
    static var previews: some View {
        let bindingInt = Binding.constant(61)
        TimePicker(textColor: ComponentColor.lightPink, interval: bindingInt)
    }
}
