//
//  TimingFeatureTests.swift
//  Athlete Zone
//
//  Created by Jan Prokorát on 11.01.2025.
//

@testable import Athlete_Zone
import ComposableArchitecture
import XCTest

@MainActor
final class TimingFeatureTests: XCTestCase {
    func testStartTimer_WithoutBackgroundMode() async {
        let clock = TestClock()
        let store = TestStore(initialState: TimingFeature.State(timerTickInterval: 1.0)) {
            TimingFeature()
        } withDependencies: {
            $0.continuousClock = clock
            $0.appStorageManager.getRunInBackground = { false }
        }

        await store.send(.startTimer) {
            $0.isTimerActive = true
        }

        await store.receive(\.startTicking)

        await clock.advance(by: .seconds(1))
        await store.receive(\.delegate, .timerTick)

        await clock.advance(by: .seconds(1))
        await store.receive(\.delegate, .timerTick)

        // Clean up any remaining effects
        await store.send(.stopTimer) {
            $0.isTimerActive = false
        }
    }

    func testStartTimer_WithBackgroundMode() async {
        let clock = TestClock()
        let store = TestStore(initialState: TimingFeature.State(timerTickInterval: 1.0)) {
            TimingFeature()
        } withDependencies: {
            $0.continuousClock = clock
            $0.appStorageManager.getRunInBackground = { true }
        }

        await store.send(.startTimer) {
            $0.isTimerActive = true
        }

        await store.receive(\.startBackgroundTask)
        await store.receive(\.startTicking)

        await store.receive(\.backgroundTaskStarted) {
            $0.backgroundTask = UIBackgroundTaskIdentifier(rawValue: 2)
        }

        await clock.advance(by: .seconds(1))
        await store.receive(\.delegate, .timerTick)

        await store.send(.stopTimer) {
            $0.isTimerActive = false
        }

        await store.receive(\.endBackgroundTask) {
            $0.backgroundTask = .invalid
        }
    }

    func testStopTimer_WithoutBackgroundMode() async {
        let clock = TestClock()
        let store = TestStore(initialState: TimingFeature.State(timerTickInterval: 1.0, isTimerActive: true)) {
            TimingFeature()
        } withDependencies: {
            $0.continuousClock = clock
            $0.appStorageManager.getRunInBackground = { false }
        }

        await store.send(.stopTimer) {
            $0.isTimerActive = false
        }

        // Verify no more ticks are received
        await clock.advance(by: .seconds(1))
        // No .timerTick actions should be received
    }

    func testStopTimer_WithBackgroundMode() async {
        let taskId = UIBackgroundTaskIdentifier(rawValue: 123)
        let clock = TestClock()
        let store = TestStore(initialState: TimingFeature.State(
            timerTickInterval: 1.0,
            isTimerActive: true,
            backgroundTask: taskId
        )) {
            TimingFeature()
        } withDependencies: {
            $0.continuousClock = clock
            $0.appStorageManager.getRunInBackground = { true }
        }

        await store.send(.stopTimer) {
            $0.isTimerActive = false
        }

        await store.receive(\.endBackgroundTask) {
            $0.backgroundTask = .invalid
        }

        // Verify no more ticks are received
        await clock.advance(by: .seconds(1))
        // No .timerTick actions should be received
    }

    func testStartTimer_WhenAlreadyActive() async {
        let store = TestStore(initialState: TimingFeature.State(
            timerTickInterval: 1.0,
            isTimerActive: true
        )) {
            TimingFeature()
        }

        await store.send(.startTimer)
        // Verify no state changes and no effects
    }

    func testStopTimer_WhenAlreadyInactive() async {
        let store = TestStore(initialState: TimingFeature.State(
            timerTickInterval: 1.0,
            isTimerActive: false
        )) {
            TimingFeature()
        }

        await store.send(.stopTimer)
        // Verify no state changes and no effects
    }
}
