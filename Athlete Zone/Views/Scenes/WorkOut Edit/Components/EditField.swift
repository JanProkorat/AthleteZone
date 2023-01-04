//
//  EditField.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 16.11.2022.
//

import SwiftUI

struct EditField: View {
    @State private var nameValue: String = ""

    var value: String = ""
    let label: String
    let labelSize: CGFloat
    let fieldSize: CGFloat
    let color: ComponentColor
    let type: InputType

    init(value: String, label: String, labelSize: CGFloat, fieldSize: CGFloat, color: ComponentColor, type: InputType) {
        if type == .text {
            self.nameValue = value
        } else {
            self.value = value
        }
        self.label = label
        self.labelSize = labelSize
        self.fieldSize = fieldSize
        self.color = color
        self.type = type
    }

    var onTab: (() -> Void)?
    var onNameChange: ((_ value: String) -> Void)?

    var body: some View {
        VStack(alignment: .center, spacing: 5) {
            Text(label)
                .font(.custom("Lato-Black", size: labelSize))
                .bold()
                .foregroundColor(Color(color.rawValue))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 25)

            switch type {
            case .text:
                TextField("Enter \(label)...", text: $nameValue)
                    .textFieldStyle(TextInputStyle(height: self.fieldSize))
                    .frame(height: fieldSize)

            default:
                ActionButton(
                    innerComponent: ActionView(
                        text: value,
                        color: ComponentColor.mainText,
                        backgoundColor: Background.background.rawValue,
                        image: nil,
                        height: fieldSize,
                        cornerRadius: 10))
                    .onTab {
                        self.performAction(self.onTab)
                    }
                    .padding([.leading, .trailing])
            }
        }
        .onChange(of: self.nameValue) { newValue in
            self.performAction(self.onNameChange, value: newValue)
        }
    }
}

struct EditField_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            EditField(value: "title", label: "Name", labelSize: 30, fieldSize: 30, color: .work, type: .text)
            EditField(value: "00:30", label: "Work", labelSize: 30, fieldSize: 30, color: .work, type: .time)
            EditField(value: "1x", label: "Rounds", labelSize: 30, fieldSize: 30, color: .work, type: .number)
        }
    }
}

struct TextInputStyle: TextFieldStyle {
    let height: CGFloat

    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(Background.background.rawValue))
                    .frame(height: height * 0.7)
            ).padding()
    }
}

extension EditField {
    func onTab(_ handler: @escaping () -> Void) -> EditField {
        var new = self
        new.onTab = handler
        return new
    }

    func onNameChange(_ handler: @escaping (_ value: String) -> Void) -> EditField {
        var new = self
        new.onNameChange = handler
        return new
    }
}
