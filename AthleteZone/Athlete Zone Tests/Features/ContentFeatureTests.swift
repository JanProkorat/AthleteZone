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
            $0.appStorageManager.getStopWatchType = { .stopWatch }
            $0.appStorageManager.getLanguage = { .en }
            $0.appStorageManager.getNotificationsEnabled = { false }
        }

        await store.send(.onAppear)
        await store.receive(\.sectionChanged, .workout)
        await store.receive(\.destination.presented.workout.onAppear)
        await store.receive(\.destination.presented.workout.tabChanged, .home)
        await store.receive(\.destination.presented.workout.destination.presented.workout.onAppear)
        await store.receive(\.destination.presented.workout.destination.presented.workout.observeSaveTapped)

        await store.receive(\.observeTabChange)
        await store.receive(\.tabChanged, .home)

        await store.receive(\.observeTitleChange)
        await store.receive(\.titleChanged, "")

        await store.receive(\.observeLanguageChange)
        await store.receive(\.languageChanged, .en)

        await store.receive(\.observeSubscriptionSheetVisibilityChange)
        await store.receive(\.subscriptionSheetVisibilityChanged, false)

        await store.receive(\.launchScreenStateChanged, .secondStep)
        try? await Task.sleep(for: Duration.seconds(1))
        await store.receive(\.launchScreenStateChanged, .finished)

        await store.send(.cancelAllObservers)
        await store.receive(\.destination.presented.workout.cancelAllObservers)
        await store.receive(\.destination.presented.workout.destination.presented.workout.cancelAllObservers)
        await store.receive(\.destination.presented.workout.cancelTabChangeObserver)
        await store.finish()
    }

//    func testSectionChanged() async {
//        let store = TestStore(
//            initialState: ContentFeature.State(),
//            reducer: { ContentFeature() }
//        ) {
//            $0.appStorageManager.storeSectionToAppStorage = { _ in }
//        }
//
//        // Test changing to training section
//        await store.send(.sectionChanged(.training)) {
//            $0.currentSection = .training
//            $0.destination = .training(TrainingContentFeature.State(currentTab: .home))
//        }
//        await store.receive(\.destination(.presented(.training(.onAppear))))
//
//        // Test changing to stopwatch section
//        await store.send(.sectionChanged(.stopWatch)) {
//            $0.currentSection = .stopWatch
//            $0.destination = .stopwatch(TimeTrackingContentFeature.State(currentTab: .home))
//        }
//        await store.receive(\.destination(.presented(.stopwatch(.onAppear))))
//
//        // Test changing to workout section
//        await store.send(.sectionChanged(.workout)) {
//            $0.currentSection = .workout
//            $0.destination = .workout(WorkoutContentFeature.State(currentTab: .home))
//        }
//        await store.receive(\.destination(.presented(.workout(.onAppear))))
//    }
//
//    func testLanguageChanged() async {
//        let store = TestStore(
//            initialState: ContentFeature.State(),
//            reducer: { ContentFeature() }
//        )
//
//        await store.send(.languageChanged(.de)) {
//            $0.currentLanguage = .de
//        }
//    }
//
//    func testLaunchScreenStateChanged() async {
//        let store = TestStore(
//            initialState: ContentFeature.State(),
//            reducer: { ContentFeature() }
//        )
//
//        await store.send(.launchScreenStateChanged(.secondStep)) {
//            $0.launchScreenState = .secondStep
//        }
//
//        await store.send(.launchScreenStateChanged(.finished)) {
//            $0.launchScreenState = .finished
//        }
//    }
//
//    func testTabChanged() async {
//        let store = TestStore(
//            initialState: ContentFeature.State(),
//            reducer: { ContentFeature() }
//        ) {
//            $0.appStateManager.updateTab = { _ in }
//        }
//
//        await store.send(.tabChanged(.settings)) {
//            $0.currentTab = .settings
//        }
//    }
//
//    func testSaveTapped() async {
//        let store = TestStore(
//            initialState: ContentFeature.State(),
//            reducer: { ContentFeature() }
//        ) {
//            $0.appStateManager.updateSaveTapped = { _ in }
//        }
//
//        await store.send(.saveTapped)
//    }
//
//    func testTitleChanged() async {
//        let store = TestStore(
//            initialState: ContentFeature.State(),
//            reducer: { ContentFeature() }
//        )
//
//        await store.send(.titleChanged("New Title")) {
//            $0.title = "New Title"
//        }
//    }
//
//    func testTimeTractingSectionChanged() async {
//        let store = TestStore(
//            initialState: ContentFeature.State(),
//            reducer: { ContentFeature() }
//        ) {
//            $0.appStorageManager.storeStopWatchTypeToAppStorage = { _ in }
//            $0.appStateManager.updateTimeTrackingType = { _ in }
//        }
//
//        await store.send(.timeTractingSectionChanged(.timer)) {
//            $0.timeTractingSection = .timer
//        }
//    }
}
