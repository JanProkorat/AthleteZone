//
//  ContentView.swift
//  AthleteZoneMini Watch App
//
//  Created by Jan Prokorát on 08.01.2023.
//

import ComposableArchitecture
import SwiftUI

struct ContentView: View {
    @Bindable var store: StoreOf<ContentFeature>
    @ObservedObject var connectivityManager = ConnectivityManager.shared

    var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            List {
                NavigationLink(state: ContentFeature.Path.State.workouts(
                    WorkoutsFeature.State(workouts: store.workouts)))
                {
                    SectionView(image: "figure.strengthtraining.traditional", label: .workout)
                }

                NavigationLink(state: ContentFeature.Path.State.trainings(
                    TrainingsFeature.State(trainings: store.trainings)))
                {
                    SectionView(image: "pencil.and.list.clipboard", label: .training)
                }

                NavigationLink(state: ContentFeature.Path.State.stopwatch(StopwatchFeature.State())) {
                    SectionView(image: "stopwatch", label: .stopWatch)
                }

                NavigationLink(state: ContentFeature.Path.State.timer(TimerFeature.State())) {
                    SectionView(image: "timer", label: .timer)
                }
            }
            .padding([.leading, .trailing], 5)
            .navigationTitle(LocalizationKey.sections.localizedKey)

        } destination: { store in
            switch store.case {
            case .workouts(let store):
                WorkoutsView(store: store)
                    .navigationTitle(LocalizationKey.workouts.localizedKey)

            case .trainings(let store):
                TrainingsView(store: store)
                    .navigationTitle(LocalizationKey.trainings.localizedKey)

            case .stopwatch(let store):
                StopwatchView(store: store)
                    .navigationTitle(LocalizationKey.stopWatch.localizedKey)

            case .timer(let store):
                TimerView(store: store)
                    .navigationTitle(LocalizationKey.timer.localizedKey)

            case .workoutRun(let store):
                WorkoutRunView(store: store)
                    .navigationBarBackButtonHidden(true)

            case .trainingRun(let store):
                TrainingRunView(store: store)
                    .navigationBarBackButtonHidden(true)

            case .stopwatchRun(let store):
                StopwatchRunView(store: store)
                    .navigationBarBackButtonHidden(true)

            case .timerRun(let store):
                TimerRunView(store: store)
                    .navigationBarBackButtonHidden(true)
            }
        }
        .background(Color(ComponentColor.darkBlue.rawValue))
        .environment(\.locale, .init(identifier: "\(store.language)"))
        .overlay {
            if store.launchScreenState != .finished {
                LaunchScreenView(launchScreenState: store.launchScreenState)
            }
        }
        .onChange(of: connectivityManager.isSessionReachable) { _, newValue in
            if newValue && store.launchScreenState == .firstStep {
                store.send(.requestData)
            }
        }
        .onChange(of: connectivityManager.receivedMessage) { oldValue, newValue in
            if oldValue != newValue {
                store.send(.dataReceived(newValue))
            }
        }
        .onAppear {
            store.send(.onAppear)
        }
    }
}

#Preview {
    ContentView(store: ComposableArchitecture.Store(initialState: ContentFeature.State(launchScreenState: .finished)) {
        ContentFeature()
            ._printChanges()
    })
}
