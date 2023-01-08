//
//  ExerciseEditContent.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 15.11.2022.
//

import SwiftUI

struct WorkOutEditContent: View {
    @EnvironmentObject var router: ViewRouter

    var onNameChange: ((_ value: String) -> Void)?
    var onEditFieldTab: ((_ value: ActivityType) -> Void)?

    var name = ""
    var work = 0
    var rest = 0
    var series = 0
    var rounds = 0
    var reset = 0

    init(_ name: String, _ work: Int, _ rest: Int, _ series: Int, _ rounds: Int, _ reset: Int) {
        self.name = name
        self.work = work
        self.rest = rest
        self.series = series
        self.rounds = rounds
        self.reset = reset
    }

    let editFieldConfig = ActivityType.allCases.chunked(into: 2)

    var body: some View {
        VStack(spacing: 15) {
            VStack(alignment: .leading, spacing: 5) {
                EditField(
                    value: name,
                    label: "Name",
                    labelSize: 23,
                    fieldSize: 50,
                    color: ComponentColor.mainText,
                    type: .text
                )
                .onNameChange { self.performAction(self.onNameChange, value: $0) }
                .padding([.top, .bottom])
            }
            .frame(alignment: .leading)
            .frame(maxWidth: .infinity)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(ComponentColor.menu.rawValue))
            )

            VStack(spacing: 0) {
                ForEach(editFieldConfig, id: \.first?.id) { chunk in
                    HStack {
                        EditField(
                            value: getValueByType(chunk.first!),
                            label: chunk.first!.rawValue,
                            labelSize: 23,
                            fieldSize: 40,
                            color: ComponentColor.allCases
                                .first(where: { chunk.first!.rawValue.contains($0.rawValue) })!,
                            type: .time
                        )
                        .onTab { performAction(self.onEditFieldTab, value: chunk.first!) }

                        if chunk.count > 1 {
                            EditField(
                                value: getValueByType(chunk.last!),
                                label: chunk.last!.rawValue,
                                labelSize: 20,
                                fieldSize: 40,
                                color: ComponentColor.allCases
                                    .first(where: { chunk.last!.rawValue.contains($0.rawValue) })!,
                                type: .time
                            )
                            .onTab { performAction(self.onEditFieldTab, value: chunk.last!) }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.top, .bottom], 10)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(ComponentColor.menu.rawValue))
            )
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }

    func getValueByType(_ type: ActivityType) -> String {
        switch type {
        case .work:
            return work.toFormattedTime()

        case .rest:
            return rest.toFormattedTime()

        case .series:
            return series.toFormattedValue(type: .number)

        case .rounds:
            return rounds.toFormattedValue(type: .number)

        case .reset:
            return reset.toFormattedTime()
        }
    }
}

struct ExerciseEditContent_Previews: PreviewProvider {
    static var previews: some View {
        WorkOutEditContent("Title", 30, 15, 7, 2, 45)
            .environmentObject(WorkOutViewModel())
            .environmentObject(ViewRouter())
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

struct TextFieldClearButton: ViewModifier {
    @Binding var text: String

    func body(content: Content) -> some View {
        HStack {
            content

            if !text.isEmpty {
                Button(
                    action: { self.text = "" },
                    label: {
                        Image(systemName: "clear")
                            .foregroundColor(Color(ComponentColor.mainText.rawValue))
                    }
                )
            }
        }
    }
}
