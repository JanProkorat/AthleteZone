//
//  ActivityEditView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 01.01.2024.
//

import RealmSwift
import SwiftUI

struct ActivityEditView: View {
    var splitTimes: [TimeInterval]
    @State var name: String

    var onCloseTab: (() -> Void)?
    var onSaveTab: ((_ name: String) -> Void)?

    init(name: String, splitTimes: [TimeInterval]) {
        _name = State(initialValue: name)
        self.splitTimes = splitTimes
    }

    var body: some View {
        VStack {
            VStack {
                TitleText(text: LocalizationKey.editActivity.rawValue, alignment: .center)
                    .padding([.leading, .trailing], 10)
                    .padding(.top)
                    .frame(maxWidth: .infinity)

                VStack(alignment: .leading, spacing: 5) {
                    EditField(label: LocalizationKey.name, labelSize: 23, color: ComponentColor.mainText) {
                        TextInput(text: $name)
                    }
                    .padding([.top, .bottom])
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .roundedBackground(cornerRadius: 20)
            }
            .padding([.leading, .trailing], 10)

            Spacer()

            SplitTimesView(splitTimes: splitTimes)
                .padding(.top)

            Spacer()

            VStack(spacing: 5) {
                ActionButton(content: {
                    ActionView(
                        text: LocalizationKey.save,
                        color: name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .grey : .lightGreen,
                        backgoundColor: ComponentColor.menu.rawValue,
                        image: Icon.check.rawValue,
                        height: 60,
                        cornerRadius: nil
                    )
                })
                .onTab { self.performAction(onSaveTab, value: name) }
                .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)

                ActionButton(content: {
                    ActionView(
                        text: LocalizationKey.cancel,
                        color: ComponentColor.lightPink,
                        backgoundColor: ComponentColor.menu.rawValue,
                        image: Icon.clear.rawValue,
                        height: 60,
                        cornerRadius: nil
                    )
                })
                .onTab { self.performAction(self.onCloseTab) }
            }
            .padding([.leading, .trailing], 10)
        }
        .background(Color(ComponentColor.darkBlue.rawValue))
        .environment(\.colorScheme, .dark)
        .ignoresSafeArea(.keyboard, edges: [.bottom])
    }
}

#Preview {
    ActivityEditView(name: "test", splitTimes: [1, 5, 7, 15, 78])
}

extension ActivityEditView {
    func onCloseTab(_ handler: @escaping () -> Void) -> ActivityEditView {
        var new = self
        new.onCloseTab = handler
        return new
    }

    func onSaveTab(_ handler: @escaping (_ name: String) -> Void) -> ActivityEditView {
        var new = self
        new.onSaveTab = handler
        return new
    }
}
