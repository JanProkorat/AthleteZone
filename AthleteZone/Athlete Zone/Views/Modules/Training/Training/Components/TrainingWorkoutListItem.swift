//
//  TrainingWorkoutListItem.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 30.03.2023.
//

import SwiftUI

struct TrainingWorkoutListItem: View {
    let workout: WorkoutDto
    let height: CGFloat

    var onInfoTab: (() -> Void)?

    var body: some View {
        Button {
            performAction(onInfoTab)
        } label: {
            HStack {
                Text(workout.name)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.subheadline)

                Text(workout.workoutLength.toFormattedTime())
                    .font(.subheadline)
                    .padding(.leading)

                Image(systemName: "line.3.horizontal")
                    .frame(height: height * 0.03)
                    .padding(.leading)
                    .foregroundColor(Color(ComponentColor.darkBlue.rawValue))
            }
            .padding([.leading, .trailing])
            .background(ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color(ComponentColor.menu.rawValue))
                    .frame(height: height)
            })
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .padding(.bottom, 2)
            .background(Color(ComponentColor.darkBlue.rawValue))
        }
        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
    }
}

struct TrainingWorkoutListItem_Previews: PreviewProvider {
    static var previews: some View {
        TrainingWorkoutListItem(
            workout: WorkoutDto(
                id: UUID(),
                name: "test",
                work: 30,
                rest: 60,
                series: 5,
                rounds: 3,
                reset: 60,
                createdDate: Date(),
                workoutLength: 180
            ),
            height: 50
        )
    }
}

extension TrainingWorkoutListItem {
    func onInfoTab(_ handler: @escaping () -> Void) -> TrainingWorkoutListItem {
        var new = self
        new.onInfoTab = handler
        return new
    }
}
