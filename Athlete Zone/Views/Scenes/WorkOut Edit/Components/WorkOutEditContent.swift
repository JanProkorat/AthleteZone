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

    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 15) {
                VStack(alignment: .leading, spacing: 5) {
                    EditField(
                        value: name,
                        label: "Name",
                        labelSize: geo.size.height * 0.04,
                        fieldSize: geo.size.height * 0.1,
                        color: Colors.MainText,
                        type: .text
                    )
                    .onNameChange { self.performAction(self.onNameChange, value: $0) }
                }
                .frame(alignment: .leading)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(Colors.Menu))
                )

                VStack(alignment: .leading, spacing: 5) {
                    HStack(alignment: .center, spacing: 5) {
                        EditField(
                            value: work.toFormattedTime(),
                            label: "Work",
                            labelSize: geo.size.height * 0.04,
                            fieldSize: geo.size.height * 0.07,
                            color: Colors.Work,
                            type: .time
                        )
                        .onTab { self.router.setActiveEditSheet(.work) }

                        EditField(
                            value: rounds.toFormattedValue(type: .number),
                            label: "Rounds",
                            labelSize: geo.size.height * 0.04,
                            fieldSize: geo.size.height * 0.07,
                            color: Colors.Rounds,
                            type: .number
                        )
                        .onTab { self.router.setActiveEditSheet(.rounds) }
                    }
                    .frame(height: geo.size.height * 0.55 * 0.25)
                    .padding(.top)

                    HStack(alignment: .center, spacing: 5) {
                        EditField(
                            value: rest.toFormattedTime(),
                            label: "Rest",
                            labelSize: geo.size.height * 0.04,
                            fieldSize: geo.size.height * 0.07,
                            color: Colors.Rest,
                            type: .time
                        )
                        .onTab { self.router.setActiveEditSheet(.rest) }

                        EditField(
                            value: reset.toFormattedTime(),
                            label: "Reset",
                            labelSize: geo.size.height * 0.04,
                            fieldSize: geo.size.height * 0.07,
                            color: Colors.Reset,
                            type: .time
                        )
                        .onTab { self.router.setActiveEditSheet(.reset) }
                    }
                    .frame(height: geo.size.height * 0.55 * 0.25)
                    .padding(.top, 10)

                    HStack(alignment: .center, spacing: 5) {
                        EditField(
                            value: series.toFormattedValue(type: .number),
                            label: "Series",
                            labelSize: geo.size.height * 0.04,
                            fieldSize: geo.size.height * 0.07,
                            color: Colors.Series,
                            type: .number
                        )
                        .onTab { self.router.setActiveEditSheet(.series) }

                        VStack(alignment: .leading, spacing: 5) {}
                            .frame(maxWidth: .infinity)
                    }
                    .frame(height: geo.size.height * 0.55 * 0.25)
                    .padding(.top, 10)
                }
                .frame(height: geo.size.height * 0.72, alignment: .top)
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(Colors.Menu))
                )
            }
        }
        .padding([.leading, .trailing, .top])
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
                            .foregroundColor(Color(Colors.MainText))
                    }
                )
            }
        }
    }
}
