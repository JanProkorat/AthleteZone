//
//  TrainingsView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 15.05.2024.
//

import ComposableArchitecture
import SwiftUI

struct TrainingsView: View {
    @Bindable var store: StoreOf<TrainingsFeature>

    var body: some View {
        NavigationView {
            List {
                ForEach(store.trainings, id: \.id) { training in
                    NavigationLink(state: ContentFeature.Path.State.trainingRun(TrainingRunFeature.State(training: training))) {
                        HStack {
                            VStack {
                                Text(training.name)
                                    .font(.title3)
                                    .frame(maxWidth: .infinity, alignment: .leading)

                                Text(training.trainingLength.toFormattedTime())
                                    .font(.caption2)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 5)
                                    .italic()
                            }
                            .frame(maxWidth: .infinity)
                            .padding([.leading, .trailing], 5)

                            Image(systemName: "info.circle")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 23, height: 23)
                                .padding(.trailing)
                                .foregroundStyle(Color(ComponentColor.buttonGreen.rawValue))
                                .onTapGesture {
                                    store.send(.trainingSelected(training))
                                }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .padding([.leading, .trailing], 5)
            .padding(.top, 20)
        }
        .sheet(item: $store.selectedTraining.sending(\.trainingSelected)) { training in
            TrainingDetailView(training: training)
        }
    }
}

#Preview {
    TrainingsView(store: ComposableArchitecture.Store(initialState: TrainingsFeature.State(trainings: [
        TrainingDto(
            id: "1",
            name: "Name",
            trainingDescription: "description",
            workoutsCount: 5,
            trainingLength: 3600,
            createdDate: Date(),
            workouts: [WorkoutDto(
                id: UUID(),
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
                id: UUID(),
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
                id: UUID(),
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
                id: UUID(),
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
                id: UUID(),
                name: "Prvni",
                work: 2,
                rest: 2,
                series: 2,
                rounds: 2,
                reset: 30,
                createdDate: Date(),
                workoutLength: 50
            )]
        ),
    ])) {
        TrainingsFeature()
            ._printChanges()
    })
}
