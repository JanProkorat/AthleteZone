//
//  ContentFeatureTests.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 12.04.2024.
//

@testable import Athlete_Zone
import ComposableArchitecture
import XCTest

@MainActor
final class ContentFeatureTests: XCTestCase {
    func testOnAppear() async {
        let store = TestStore(initialState: ContentFeature.State()) {
            ContentFeature()
        } withDependencies: {
            $0.appStorageManager.getSelectedSection = { .workout }
            $0.appStorageManager.getLanguage = { .en }
            $0.appStorageManager.getNotificationsEnabled = { true }
            $0.notificationManager.requestAuthorization = {}
        }

        await store.send(.onAppear)

        await store.receive(\.sectionChanged, .workout)

        await store.receive(\.languageChanged, .en)

        await store.receive(\.launchScreenStateChanged, .secondStep)

        // Wait for 1 second delay
        try? await Task.sleep(for: Duration.seconds(1))
        
        await store.receive(\.launchScreenStateChanged, .finished)
    }

    func testOnAppearWithStopWatch() async {
        let store = TestStore(initialState: ContentFeature.State()) {
            ContentFeature()
        } withDependencies: {
            $0.appStorageManager.getSelectedSection = { .stopWatch }
            $0.appStorageManager.getStopWatchType = { .stopWatch }
            $0.appStorageManager.getLanguage = { .en }
            $0.appStorageManager.getNotificationsEnabled = { false }
        }

        await store.send(.onAppear)

        await store.receive(\.sectionChanged, .stopWatch)

        await store.receive(\.timeTractingSectionChanged, .stopWatch)

        await store.receive(\.languageChanged, .en)

        await store.receive(\.launchScreenStateChanged, .secondStep)

        // Wait for 1 second delay
        try? await Task.sleep(for: Duration.seconds(1))

        await store.receive(\.launchScreenStateChanged, .finished)
    }

    func testSectionChangedToWorkout() async {
        let store = TestStore(initialState: ContentFeature.State(currentSection: .training)) {
            ContentFeature()
        } withDependencies: {
            $0.appStorageManager.storeSectionToAppStorage = { _ in }
        }

        await store.send(.sectionChanged(.workout)) {
            $0.currentSection = .workout
            $0.destination = .workout(WorkoutContentFeature.State(currentTab: .home))
        }
        
        await store.receive(\.destination.presented.workout.onAppear)
    }
    
    func testSectionChangedToTraining() async {
        let store = TestStore(initialState: ContentFeature.State(currentSection: .workout)) {
            ContentFeature()
        } withDependencies: {
            $0.appStorageManager.storeSectionToAppStorage = { _ in }
        }

        await store.send(.sectionChanged(.training)) {
            $0.currentSection = .training
            $0.destination = .training(TrainingContentFeature.State(currentTab: .home))
        }

        await store.receive(\.destination.presented.training.onAppear)
    }

    func testSectionChangedToStopWatch() async {
        let store = TestStore(initialState: ContentFeature.State(currentSection: .workout)) {
            ContentFeature()
        } withDependencies: {
            $0.appStorageManager.storeSectionToAppStorage = { _ in }
        }

        await store.send(.sectionChanged(.stopWatch)) {
            $0.currentSection = .stopWatch
            $0.destination = .stopwatch(TimeTrackingContentFeature.State(currentTab: .home))
        }

        await store.receive(\.destination.presented.stopwatch.onAppear)

        await store.receive(\.titleChanged, "stopWatch")
    }

    func testSectionChangedToSameSection() async {
        let store = TestStore(initialState: ContentFeature.State(currentSection: .workout)) {
            ContentFeature()
        } withDependencies: {
            $0.appStorageManager.storeSectionToAppStorage = { _ in }
        }

        await store.send(.sectionChanged(.workout))
        // No state changes or effects should occur
    }
}
