//
//  FlowStepsView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 26.11.2023.
//

import SwiftUI

struct FlowStepsView: View {
    @Binding var flowNumber: Int
    @Binding var work: Int
    @Binding var rest: Int
    @Binding var series: Int
    @Binding var rounds: Int
    @Binding var reset: Int

    @State var workSecs = 0
    @State var workMin = 0
    @State var workHours = 0

    @State var restSecs = 0
    @State var restMin = 0
    @State var restHours = 0

    @State var resetSecs = 0
    @State var resetMin = 0
    @State var resetHours = 0

    var onStartTap: (() -> Void)?

    private var workInterval: Int {
        workHours * 3600 + workMin * 60 + workSecs
    }

    private var restInterval: Int {
        restHours * 3600 + restMin * 60 + restSecs
    }

    private var resetInterval: Int {
        resetHours * 3600 + resetMin * 60 + resetSecs
    }

    private var isNextStepDisabled: Bool {
        switch flowNumber {
        case 1:
            work == 0

        case 2:
            rest == 0

        case 3:
            series == 0

        case 4:
            rounds == 0

        case 5:
            reset == 0

        default:
            true
        }
    }

    var body: some View {
        GeometryReader(content: { geo in
            VStack {
                switch flowNumber {
                case 1:
                    timeSetter(text: "Work", color: .lightPink, secs: $workSecs,
                               mins: $workMin, hours: $workHours, height: geo.size.height * 0.6)

                case 2:
                    timeSetter(text: "Rest", color: .lightYellow, secs: $restSecs,
                               mins: $restMin, hours: $restHours, height: geo.size.height * 0.6)

                case 3:
                    numberSetter(text: "Series", color: .lightBlue,
                                 value: $series, height: geo.size.height * 0.6)

                case 4:
                    numberSetter(text: "Rounds", color: .lightGreen,
                                 value: $rounds, height: geo.size.height * 0.6)

                case 5:
                    timeSetter(text: "Reset", color: .braun, secs: $resetSecs,
                               mins: $resetMin, hours: $resetHours, height: geo.size.height * 0.6)

                default:
                    Text("")
                }

                HStack {
                    backButton

                    Button {
                        if self.flowNumber < 5 {
                            self.flowNumber += 1
                        } else {
                            performAction(onStartTap)
                        }
                    } label: {
                        HStack {
                            Text(flowNumber < 5 ? "Continue" : "Start")
                                .frame(maxWidth: .infinity)
                                .font(.footnote)
                                .bold()
                                .foregroundStyle(Color(ComponentColor.darkBlue.rawValue))
                        }
                        .frame(maxWidth: .infinity)
                        .background(
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .frame(height: 25)
                                    .foregroundColor(Color(ComponentColor.buttonGreen.rawValue))
                            }
                        )
                    }
                    .buttonStyle(.plain)
                    .disabled(isNextStepDisabled)
                }
                .padding(.top, 15)
            }
            .padding([.leading, .trailing])
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        })
        .onChange(of: workInterval) { _, newValue in
            work = newValue
        }
        .onChange(of: restInterval) { _, newValue in
            rest = newValue
        }
        .onChange(of: resetInterval) { _, newValue in
            reset = newValue
        }
    }

    @ViewBuilder
    private func timeSetter(
        text: String,
        color: ComponentColor,
        secs: Binding<Int>,
        mins: Binding<Int>,
        hours: Binding<Int>,
        height: CGFloat
    ) -> some View {
        VStack {
            Text(text)
                .foregroundStyle(Color(color.rawValue))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .padding(.top, -12)
            HStack {
                valuePicker(value: hours, maxValue: 60, color: color, height: height)
                descriptionText(text: ":", color: color)

                valuePicker(value: mins, maxValue: 60, color: color, height: height)
                descriptionText(text: ":", color: color)

                valuePicker(value: secs, maxValue: 60, color: color, height: height)
            }
            .padding(.top, 8)
        }
    }

    @ViewBuilder
    private func numberSetter(text: String, color: ComponentColor, value: Binding<Int>, height: CGFloat) -> some View {
        VStack {
            Text(text)
                .foregroundStyle(Color(color.rawValue))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading)
                .padding(.top, -12)

            valuePicker(value: value, maxValue: 23, color: color, height: height)
                .padding(.top, 8)
        }
    }

    @ViewBuilder
    private var backButton: some View {
        Button {
            self.flowNumber -= 1
        } label: {
            HStack {
                Text("Back")
                    .frame(maxWidth: .infinity)
                    .font(.footnote)
                    .bold()
                    .foregroundStyle(Color(ComponentColor.darkBlue.rawValue))
            }
            .frame(maxWidth: .infinity)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 25)
                        .foregroundColor(Color(ComponentColor.buttonGreen.rawValue))
                }
            )
        }
        .buttonStyle(.plain)
        .disabled(self.flowNumber == 0)
    }

    @ViewBuilder
    private func valuePicker(value: Binding<Int>, maxValue: Int,
                             color: ComponentColor, height: CGFloat) -> some View
    {
        Picker("", selection: value) {
            ForEach((0 ..< maxValue).reversed(), id: \.self) {
                Text("\($0)")
                    .foregroundStyle(Color(color.rawValue))
            }
        }
        .labelsHidden()
        .frame(maxWidth: 40, maxHeight: height)
    }

    @ViewBuilder
    private func descriptionText(text: String, color: ComponentColor) -> some View {
        Text(text)
            .font(.largeTitle)
            .foregroundStyle(Color(color.rawValue))
            .padding(.bottom)
    }
}

extension FlowStepsView {
    func onStartTap(_ handler: @escaping () -> Void) -> FlowStepsView {
        var new = self
        new.onStartTap = handler
        return new
    }
}

#Preview {
    FlowStepsView(
        flowNumber: Binding.constant(1),
        work: Binding.constant(1),
        rest: Binding.constant(1),
        series: Binding.constant(1),
        rounds: Binding.constant(1),
        reset: Binding.constant(1)
    )
}
