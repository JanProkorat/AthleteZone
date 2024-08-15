//
//  TrainingView.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 27.02.2024.
//

import ComposableArchitecture
import SwiftUI

struct TrainingView: View {
    @Bindable var store: StoreOf<TrainingFeature>

    var body: some View {
        GeometryReader { geo in
            VStack {
                if let selectedTraining = store.selectedTraining {
                    VStack {
                        EditSection(
                            icon: "square.and.pencil.circle",
                            label: LocalizationKey.description,
                            color: ComponentColor.lightBlue
                        ) {
                            ScrollView {
                                Text(selectedTraining.trainingDescription)
                                    .font(.subheadline)
                                    .padding(.top, 7)
                                    .frame(maxWidth: .infinity)
                                    .padding([.leading, .trailing])
                            }
                            .frame(maxHeight: geo.size.height * 0.2)
                            .frame(maxWidth: .infinity)
                            .roundedBackground(cornerRadius: 10, color: ComponentColor.darkBlue)
                            .padding(.bottom, 7)
                        }
                    }
                    .roundedBackground(cornerRadius: 20)

                    ZStack(alignment: .top) {
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color(ComponentColor.menu.rawValue))
                            .frame(height: 50)
                        Collapsible {
                            HStack(alignment: .center) {
                                Image(systemName: "figure.run.circle")
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(Color(ComponentColor.lightGreen.rawValue))
                                    .frame(maxWidth: 25, maxHeight: 25)
                                    .padding(.top, 5)

                                Text(LocalizationKey.workouts.localizedKey)
                                    .font(.title2)
                                    .foregroundColor(Color(ComponentColor.lightGreen.rawValue))
                                    .padding(.leading, 5)
                                    .padding(.top, 4)
                            }
                            .padding(.top, 4)

                        } content: {
                            List {
                                ForEach(selectedTraining.workouts, id: \.id) { workout in
                                    TrainingWorkoutListItem(workout: workout, height: geo.size.height * 0.07)
                                        .onInfoTab { store.send(.workoutForDetailChanged(workout)) }
                                }
                                .onMove { from, to in
                                    store.send(.move(from, to))
                                }
                            }
                            .listStyle(.plain)
                            .overlay(alignment: .top) {
                                if store.selectedTraining != nil && store.selectedTraining!.workouts.isEmpty {
                                    Text(LocalizationKey.noWorkoutsInTraining.localizedKey)
                                        .font(.footnote)
                                        .padding([.top, .leading, .trailing])
                                }
                            }
                        }
                        .padding([.leading, .trailing], 5)
                        .padding(.top, 2)
                    }

                    Spacer()

                    HStack {
                        EditSection(
                            icon: "play.circle",
                            label: LocalizationKey.summary,
                            color: ComponentColor.lightPink,
                            disabled: true
                        ) {
                            VStack(spacing: 7) {
                                HStack {
                                    Text(LocalizationKey.length.localizedKey)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(selectedTraining.trainingLength.toFormattedTime())
                                }
                                .padding([.leading, .trailing])

                                HStack {
                                    Text(LocalizationKey.workouts.localizedKey)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(selectedTraining.workouts.count.toFormattedNumber())
                                }
                                .padding([.leading, .trailing])
                            }
                            .padding(.bottom)
                        }

                        HStack {
                            Button {
                                store.send(.startTapped)
                            } label: {
                                Image(Icon.start.rawValue)
                                    .resizable()
                                    .scaledToFill()
                                    .foregroundColor(Color(store.isRunDisabled ?
                                            ComponentColor.grey.rawValue :
                                            ComponentColor.action.rawValue))
                                    .frame(maxWidth: geo.size.height * 0.15, maxHeight: geo.size.height * 0.15)
                            }
                            .disabled(store.isRunDisabled)
                        }
                        .frame(maxWidth: geo.size.width * 0.35)
                    }
                    .frame(maxWidth: .infinity, maxHeight: geo.size.height * 0.2)
                    .roundedBackground(cornerRadius: 20)
                } else {
                    VStack(alignment: .center) {
                        HStack {
                            IconButton(
                                id: "createTraining",
                                image: Icon.addLarge.rawValue,
                                color: ComponentColor.mainText,
                                width: 100,
                                height: 100
                            )
                            .onTab {
                                store.send(.addTapped)
                            }

                            IconButton(
                                id: "pickTraining",
                                image: Icon.bookLarge.rawValue,
                                color: ComponentColor.mainText,
                                width: 100,
                                height: 100
                            )
                            .onTab {
                                store.send(.libraryTapped)
                            }
                            .padding(.leading)
                            .padding(.top, 5)
                        }
                        Text(LocalizationKey.noTrainingSelected.localizedKey)
                            .padding(.top)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
        }
        .sheet(item: $store.workoutForDetail.sending(\.workoutForDetailChanged)) { _ in
            WorkoutDetailSheet(workout: $store.workoutForDetail.sending(\.workoutForDetailChanged))
                .presentationDetents([.fraction(0.4)])
        }
        .sheet(item: $store.scope(state: \.destination?.editSheet, action: \.destination.editSheet)) { store in
            TrainingEditView(store: store)
        }
        .fullScreenCover(item: $store.scope(state: \.destination?.runSheet, action: \.destination.runSheet)) { store in
            TrainingRunView(store: store)
        }
    }
}

#Preview {
    TrainingView(store: ComposableArchitecture.Store(initialState: TrainingFeature.State(), reducer: {
        TrainingFeature()
            ._printChanges()
    }))
}
