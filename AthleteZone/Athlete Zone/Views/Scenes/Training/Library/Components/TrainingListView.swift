//
//  TrainingListView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 03.07.2023.
//

import SwiftUI

struct TrainingListView: View {
    let training: TrainingDto

    var onInfoTab: (() -> Void)?
    var onEditTab: (() -> Void)?
    var onDeleteTab: (() -> Void)?
    var onSelectTab: (() -> Void)?

    var body: some View {
        Button(action: {
            performAction(onSelectTab)
        }, label: {
            LibraryItemBaseView(name: training.name) {
                VStack(spacing: 7) {
                    descriptionView(
                        property: LocalizationKey.length.localizedKey,
                        value: training.trainingLength.toFormattedTime(),
                        color: ComponentColor.lightPink
                    )

                    descriptionView(
                        property: LocalizationKey.workouts.localizedKey,
                        value: training.workouts.count.toFormattedNumber(),
                        color: ComponentColor.lightYellow
                    )

                    descriptionView(
                        property: LocalizationKey.createdDate.localizedKey,
                        value: training.formattedCreatedDate,
                        color: ComponentColor.braun
                    )
                }
                .padding([.leading, .trailing], 30)
                .padding(.top, -10)
            }
            .onEditTab { performAction(onEditTab) }
            .onDeleteTab { performAction(onDeleteTab) }
            .onInfoTab { performAction(onInfoTab) }
        })
        .padding(.bottom, 5)
        .background(Color(ComponentColor.darkBlue.rawValue))
    }

    @ViewBuilder
    func descriptionView(property: LocalizedStringKey, value: String, color: ComponentColor) -> some View {
        HStack {
            Text(property)
                .font(.callout)
                .foregroundColor(Color(color.rawValue))
                .scaledToFill()
            Text(":")
                .font(.callout)
                .foregroundColor(Color(color.rawValue))
                .padding(.leading, -7)
            Text(value)
                .font(.callout)
                .foregroundColor(Color(color.rawValue))
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
    }
}

struct TrainingListView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingListView(
            training: TrainingDto(
                id: "1",
                name: "Name",
                trainingDescription: "description",
                workoutsCount: 5,
                trainingLength: 3600,
                createdDate: Date(),
                workouts: [WorkoutDto(
                    id: "1",
                    name: "Prvni",
                    work: 2,
                    rest: 2,
                    series: 2,
                    rounds: 2,
                    reset: 30,
                    createdDate: Date(),
                    workoutLength: 50
                ),
                WorkoutDto(
                    id: "1",
                    name: "Prvni",
                    work: 2,
                    rest: 2,
                    series: 2,
                    rounds: 2,
                    reset: 30,
                    createdDate: Date(),
                    workoutLength: 50
                ),
                WorkoutDto(
                    id: "1",
                    name: "Prvni",
                    work: 2,
                    rest: 2,
                    series: 2,
                    rounds: 2,
                    reset: 30,
                    createdDate: Date(),
                    workoutLength: 50
                ),
                WorkoutDto(
                    id: "1",
                    name: "Prvni",
                    work: 2,
                    rest: 2,
                    series: 2,
                    rounds: 2,
                    reset: 30,
                    createdDate: Date(),
                    workoutLength: 50
                ),
                WorkoutDto(
                    id: "1",
                    name: "Prvni",
                    work: 2,
                    rest: 2,
                    series: 2,
                    rounds: 2,
                    reset: 30,
                    createdDate: Date(),
                    workoutLength: 50
                )]
            ))
    }
}

extension TrainingListView {
    func onInfoTab(_ handler: @escaping () -> Void) -> TrainingListView {
        var new = self
        new.onInfoTab = handler
        return new
    }

    func onEditTab(_ handler: @escaping () -> Void) -> TrainingListView {
        var new = self
        new.onEditTab = handler
        return new
    }

    func onDeleteTab(_ handler: @escaping () -> Void) -> TrainingListView {
        var new = self
        new.onDeleteTab = handler
        return new
    }

    func onSelectTab(_ handler: @escaping () -> Void) -> TrainingListView {
        var new = self
        new.onSelectTab = handler
        return new
    }
}
