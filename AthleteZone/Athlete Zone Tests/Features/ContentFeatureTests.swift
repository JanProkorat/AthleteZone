//
//  ContentFeatureTests.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 12.04.2024.
//

@testable import Athlete_Zone
import ComposableArchitecture
import Nimble
import XCTest

class ContentFeatureTests: XCTestCase {
//    @MainActor
//    func testSectionChanged() async {
//        let store = TestStore(initialState: ContentFeature.State()) {
//            ContentFeature()
//        }
//
//        store.exhaustivity = .off
//
//        await store.send(.onAppear)
//
//        store.assert {
//            $0.currentLanguage = .cze
//        }
    ////        await store.send(.sectionChanged(.training)) {
    ////            $0.currentSection = .training
    ////            $0.destination = .training(TrainingContentFeature.State())
    ////            $0.destination?.training?.currentTab = .home
    ////        }
//
    ////        await store.send(.destination(.presented(.training(.onAppear))))
    ////        expect(store.state.currentSection).to(equal(Section.training))
//    }

    @MainActor
    func test_onAppear() async {
        let store = TestStore(initialState: ContentFeature.State()) {
            ContentFeature()
        }

        await store.send(.onAppear)
        store.assert {
            $0.currentSection = .workout
            $0.currentLanguage = .cze
            $0.subscriptionActivated = true
            $0.launchScreenState = .finished
        }

        await store.receive(.sectionChanged(.workout))
        await store.receive(.destination(.presented(.workout(.onAppear))))
        await store.finish()
    }

//    func test_sectionChangedToTraining() {
//        let store = TestStore(initialState: ContentFeature.State()) {
//            ContentFeature()
//        }
//
//        store.send(.sectionChanged(.training))
//            .assert(state: { $0.currentSection == .training })
//            .receive(.destination(.presented(.training(.onAppear))))
//    }
//
//    func test_sectionChangedToStopWatch() {
//        let store = TestStore(initialState: ContentFeature.State()) {
//            ContentFeature()
//        }
//
//        store.send(.sectionChanged(.stopWatch))
//            .assert(state: { $0.currentSection == .stopWatch })
//            .receive(.destination(.presented(.stopwatch(.onAppear))))
//            .receive(.send(.titleChanged("\(ContentFeature.TimerType.stopWatch.rawValue)")))
//            .assert(state: { $0.title == "Stopwatch" })
//            .run { _ in
//                XCTAssertTrue(appStorageManager.setSectionCalled)
//                XCTAssertTrue(appStorageManager.setStopWatchTypeCalled)
//            }
//    }
//
//    func test_tabChanged() {
//        let store = TestStore(initialState: ContentFeature.State()) {
//            ContentFeature()
//        }
//
//        store.send(.tabChanged(.home))
//            .assert(state: { $0.currentTab == .home })
//            .receive(.destination(.presented(.workout(.tabChanged(.home)))))
//            .assert(state: { $0.title == "Home" }) // Assuming title updates in workout reducer
//    }
//
//    func test_languageChanged() {
//        let store = TestStore(initialState: ContentFeature.State()) {
//            ContentFeature()
//        }
//
//        store.send(.languageChanged(.fr))
//            .assert(state: { $0.currentLanguage == .fr })
//            .run { _ in
//                XCTAssertTrue(appStorageManager.setLanguageCalled)
//            }
//    }
//
//    func test_subscriptionStatusChanged() {
//        let store = TestStore(initialState: ContentFeature.State()) {
//            ContentFeature()
//        }
//
//        store.send(.subscriptionStatusChanged(true))
//            .assert(state: { $0.subscriptionActivated == true })
//            .receive(.destination(.presented(.workout(.subscriptionActivated(true)))))
//    }
}
