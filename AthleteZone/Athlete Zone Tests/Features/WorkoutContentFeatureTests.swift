//
//  WorkoutContentFeatureTests.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 21.01.2025.
//

@testable import Athlete_Zone
import ComposableArchitecture
import XCTest

@MainActor
final class WorkoutContentFeatureTests: XCTest {
    func testOnAppear() async {
        var store = TestStore(initialState: WorkoutContentFeature.State()) {
            WorkoutContentFeature()
        }

        await store.send(.onAppear)

        await store.receive(\.observeTabChange)
        await store.receive(\.tabChanged)
        await store.receive(\.destination.presented.workout.onAppear)
        await store.receive(\.destination.presented.workout.observeSaveTapped)

        await store.send(.cancelAllObservers)
        await store.receive(\.destination.presented.workout.cancelAllObservers)
        await store.receive(\.cancelTabChangeObserver)
        await store.finish()
    }

    func testTabChanged() async {
        var store = TestStore(initialState: WorkoutContentFeature.State()) {
            WorkoutContentFeature()
        }

        await store.send(.tabChanged(.library)) {
            $0.currentTab = .library
        }

        await store.receive(\.destination.presented.library.onAppear)
        await store.receive(\.destination.presented.library.observeAddTapped)
        await store.receive(\.destination.presented.library.addTapped)
        await store.receive(\.destination.presented.library.displayData)

        await store.send(.cancelAllObservers)
        await store.receive(\.destination.presented.library.cancelAllObservers)
        await store.finish()
    }
}
