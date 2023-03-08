//
//  ExerciseEditContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import SwiftUI

struct WorkOutEditContent: View {
    @EnvironmentObject var viewModel: WorkOutEditViewModel

    var onNameChange: ((_ value: String) -> Void)?
    var onEditFieldTab: ((_ value: ActivityType) -> Void)?

    let editFieldConfig = ActivityType.allCases.chunked(into: 2)

    var body: some View {
        VStack(spacing: 15) {
            nameSection

            VStack(spacing: 0) {
                ForEach(editFieldConfig, id: \.first?.id) { chunk in
                    HStack {
                        editField(for: chunk.first!)

                        if chunk.count > 1 {
                            editField(for: chunk.last!)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top, .bottom], 10)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .roundedBackground(cornerRadius: 20)
            .padding(.bottom)
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    @ViewBuilder
    var nameSection: some View {
        VStack(alignment: .leading, spacing: 5) {
            EditField(label: "Name", labelSize: 23, color: ComponentColor.mainText) {
                TextInput(text: $viewModel.name)
            }
            .padding([.top, .bottom])
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .roundedBackground(cornerRadius: 20)
    }

    @ViewBuilder
    func editField(for type: ActivityType) -> some View {
        let label = type.rawValue
        let labelSize: CGFloat = 23
        let color = ComponentColor.allCases.first(where: { label.contains($0.rawValue) })!

        EditField(label: label, labelSize: labelSize, color: color) {
            ActionButton {
                ActionView(
                    text: self.getValueByType(type),
                    color: ComponentColor.mainText,
                    backgoundColor: Background.background.rawValue,
                    image: nil,
                    height: 40,
                    cornerRadius: 10
                )
                .overlay(
                    HStack {
                        if self.getValueByType(type) == "00:00" {
                            Image(systemName: "exclamationmark.circle")
                                .foregroundColor(.red)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.trailing, 10)
                )
            }
            .onTab { performAction(self.onEditFieldTab, value: type) }
            .padding([.leading, .trailing])
        }
    }

    func getValueByType(_ type: ActivityType) -> String {
        switch type {
        case .work:
            return viewModel.work.toFormattedTime()

        case .rest:
            return viewModel.rest.toFormattedTime()

        case .series:
            return viewModel.series.toFormattedNumber()

        case .rounds:
            return viewModel.rounds.toFormattedNumber()

        case .reset:
            return viewModel.reset.toFormattedTime()
        }
    }
}

struct ExerciseEditContent_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutEditContent()
            .environmentObject(WorkOutEditViewModel())
    }
}

extension WorkOutEditContent {
    func onNameChange(_ handler: @escaping (_ value: String) -> Void) -> WorkOutEditContent {
        var new = self
        new.onNameChange = handler
        return new
    }

    func onEditFieldTab(_ handler: @escaping (_ value: ActivityType) -> Void) -> WorkOutEditContent {
        var new = self
        new.onEditFieldTab = handler
        return new
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
