//
//  WorkoutPickerItem.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 11.07.2023.
//

import SwiftUI

struct WorkoutPickerItem: View {
    let workout: WorkoutDto
    let isSelected: Bool

    let fieldConfig: [[ActivityType]] = [.work, .rounds, .rest, .series, .reset].chunked(into: 2)

    var body: some View {
        GeometryReader { reader in
            VStack {
                HStack(alignment: .center) {
                    TitleText(text: workout.name)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)

                    Image(systemName: isSelected ? "checkmark.circle.fill" : "")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(Color(ComponentColor.mainText.rawValue))
                        .frame(width: 35, height: 35)
                        .padding(.trailing, 20)
                        .padding(.top, 5)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.top, 5)

                ForEach(fieldConfig, id: \.first?.id) { chunk in
                    HStack {
                        listViewItem(item: chunk.first!, width: reader.size.width * 0.8 * 0.5)
                        listViewItem(item: chunk.count > 1 ? chunk.last! : nil, width: reader.size.width * 0.9 * 0.5)
                    }
                    .padding(.bottom, chunk.count > 1 ? 1 : 10)
                    .frame(maxWidth: reader.size.width * 0.9, alignment: .center)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(ComponentColor.darkGrey.rawValue))
            )
        }
    }

    @ViewBuilder
    func listViewItem(item: ActivityType?, width: CGFloat) -> some View {
        HStack {
            Text(item == nil ? LocalizationKey.total.localizedKey : LocalizedStringKey(item!.rawValue))
                .font(.callout)
                .foregroundColor(Color(getColor(item)))
                .scaledToFill()
            Text(":")
                .font(.callout)
                .foregroundColor(Color(getColor(item)))
                .padding(.leading, -7)
            Text(item == nil ? self.workout.workoutLength.toFormattedTime() : getValueByType(item!))
                .font(.callout)
                .foregroundColor(Color(getColor(item)))
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing)
        }
        .frame(width: width, alignment: .leading)
    }

    private func getColor(_ type: ActivityType?) -> String {
        switch type {
        case .work:
            return ComponentColor.lightPink.rawValue

        case .rest:
            return ComponentColor.lightYellow.rawValue

        case .series:
            return ComponentColor.lightBlue.rawValue

        case .rounds:
            return ComponentColor.lightGreen.rawValue

        case .reset:
            return ComponentColor.braun.rawValue

        default:
            return ComponentColor.mainText.rawValue
        }
    }

    func getValueByType(_ type: ActivityType) -> String {
        switch type {
        case .work:
            return workout.work.toFormattedTime()

        case .rest:
            return workout.rest.toFormattedTime()

        case .series:
            return workout.series.toFormattedValue(type: .number)

        case .rounds:
            return workout.rounds.toFormattedValue(type: .number)

        case .reset:
            return workout.reset.toFormattedTime()
        }
    }
}

struct WorkoutPickerItem_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutPickerItem(
            workout: WorkoutDto(
                id: "1",
                name: "Prvni",
                work: 2,
                rest: 2,
                series: 2,
                rounds: 2,
                reset: 30,
                createdDate: Date(),
                workoutLength: 50
            ), isSelected: true
        )
    }
}
