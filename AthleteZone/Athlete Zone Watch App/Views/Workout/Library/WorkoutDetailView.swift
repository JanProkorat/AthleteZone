//
//  WorkoutDetailView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 16.05.2024.
//

import SwiftUI

struct WorkoutDetailView: View {
    var workout: WorkoutDto

    var body: some View {
        NavigationView(content: {
            ScrollView {
                HStack {
                    label(.work, .lightPink)
                    value(workout.work.toFormattedTime(), .lightPink)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 10)
                .padding([.leading, .trailing])

                Divider()
                    .padding([.leading, .trailing])

                HStack {
                    label(.rest, .lightYellow)
                    value(workout.rest.toFormattedTime(), .lightYellow)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing])

                Divider()
                    .padding([.leading, .trailing])

                HStack {
                    label(.series, .lightBlue)
                    value(workout.series.toFormattedTime(), .lightBlue)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing])

                Divider()
                    .padding([.leading, .trailing])

                HStack {
                    label(.rounds, .lightGreen)
                    value(workout.rounds.toFormattedTime(), .lightGreen)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing])

                Divider()
                    .padding([.leading, .trailing])

                HStack {
                    label(.reset, .braun)
                    value(workout.reset.toFormattedTime(), .braun)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                }
                .frame(maxWidth: .infinity)
                .padding([.leading, .trailing])
            }
            .frame(maxWidth: .infinity)
            .presentationBackground(Color(ComponentColor.darkBlue.rawValue))
            .navigationTitle(workout.name)
            .navigationBarTitleDisplayMode(.inline)
        })
    }

    @ViewBuilder
    func label(_ text: LocalizationKey, _ color: ComponentColor) -> some View {
        Text(text.localizedKey)
            .font(.caption)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(Color(color.rawValue))
            .padding(.leading)
    }

    @ViewBuilder
    func value(_ text: String, _ color: ComponentColor) -> some View {
        Text(text)
            .font(.caption)
            .foregroundStyle(Color(color.rawValue))
            .padding(.trailing)
    }
}

#Preview {
    WorkoutDetailView(workout: WorkoutDto(
        id: UUID(),
        name: "Druhy",
        work: 3,
        rest: 3,
        series: 3,
        rounds: 3,
        reset: 30,
        createdDate: Date(),
        workoutLength: 12250
    ))
}
