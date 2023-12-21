//
//  StopWatchHeader.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.11.2023.
//

import SwiftUI

struct StopWatchHeader: View {
    @Binding var state: WorkFlowState
    @Binding var section: TimerType

    var body: some View {
        HStack {
            HStack(alignment: .center) {
                SectionSwitch()
                TitleText(
                    text: section == .stopWatch ?
                        LocalizationKey.stopWatch.rawValue :
                        LocalizationKey.timer.rawValue
                )
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            sectionButton(id: "timer", .timer)
                .padding(.trailing, 3)
            sectionButton(id: "stopwatch", .stopWatch)
        }
        .disabled(state == .running || state == .paused)
        .padding(.trailing, 7)
        .opacity(state == .running || state == .paused ? 0 : 1)
    }

    @ViewBuilder
    func sectionButton(id: String, _ valueToSet: TimerType) -> some View {
        Button {
            withAnimation {
                section = valueToSet
            }
        } label: {
            if section == valueToSet {
                sectionIcon(
                    id: id,
                    color: .darkBlue,
                    background: .action,
                    border: .action
                )
            } else {
                sectionIcon(
                    id: id,
                    color: .mainText,
                    background: .darkBlue,
                    border: .mainText
                )
            }
        }
        .disabled(section == valueToSet)
    }

    @ViewBuilder
    func sectionIcon(id: String, color: ComponentColor, background: ComponentColor, border: ComponentColor) -> some View {
        Image(systemName: id)
            .resizable()
            .scaledToFit()
            .foregroundColor(Color(color.rawValue))
            .frame(maxHeight: 30)
            .padding(5)
            .roundedBackground(cornerRadius: 10, color: background, border: border)
    }
}

#Preview {
    StopWatchHeader(
        state: Binding.constant(WorkFlowState.ready),
        section: Binding.constant(.stopWatch)
    )
}
