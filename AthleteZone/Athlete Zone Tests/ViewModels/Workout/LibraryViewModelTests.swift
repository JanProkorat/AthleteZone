//
//  LibraryViewModelTests.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 22.03.2023.
//

@testable import Athlete_Zone
import Nimble
import XCTest

class LibraryViewModelTests: XCTestCase {
    var viewModel: LibraryViewModel!
    var realmManager: WorkOutRealmManagerMock!
    var connectivityManager: WatchConnectivityMock!

    override func setUp() {
        super.setUp()

        viewModel = LibraryViewModel()
        realmManager = WorkOutRealmManagerMock()
        connectivityManager = WatchConnectivityMock()
        viewModel.realmManager = realmManager
        viewModel.connectivityManager = connectivityManager
    }

    override func tearDown() {
        viewModel = nil
        realmManager = nil
        connectivityManager = nil
        super.tearDown()
    }

    func testSearchText() {
        viewModel.searchText = "Push-up"
        expect(self.viewModel.searchText).to(equal("Push-up"))
    }

    func testSortOrder() {
        viewModel.sortOrder = .descending
        expect(self.viewModel.sortOrder).to(equal(.descending))
    }

    func testSortBy() {
        viewModel.sortBy = .work
        expect(self.viewModel.sortBy).to(equal(.work))
    }

    func testSelectedWorkoutManager() {
        let selectedWorkout = WorkOut()
        viewModel.setSelectedWorkOut(selectedWorkout)
        expect(self.viewModel.selectedWorkoutManager.selectedWorkout).to(equal(selectedWorkout))
        expect(self.viewModel.selectedWorkoutManager.selectedWorkout).toNot(beNil())
    }

    func testSetSelectedWorkout() {
        let workout = WorkOut()
        realmManager.add(workout)

        viewModel.setSelectedWorkOut(workout)

        expect(self.viewModel.selectedWorkoutManager.selectedWorkout) == workout
    }

    func testSetSelectedWorkout_ById() {
        let workout = WorkOut()
        realmManager.add(workout)

        viewModel.setSelectedWorkOut(workout._id.stringValue)

        expect(self.viewModel.selectedWorkoutManager.selectedWorkout) == workout
    }

    func testRemoveWorkout() {
        let workout = WorkOut()
        realmManager.add(workout)
        viewModel.removeWorkout(workout)
        expect(self.realmManager.load(primaryKey: workout._id.stringValue)).to(beNil())

        let data = viewModel.realmManager.load()
        let identical = data.first(where: { $0._id == workout._id })
        expect(identical).to(beNil())
    }

    func testRemoveFromWatch() {
        let workout = WorkOut()
        viewModel.removeFromWatch(workout._id.stringValue)

        expect(self.connectivityManager.lastSentMessage?
            .first(where: { $0.key == TransferDataKey.workoutRemove.rawValue })).notTo(beNil())
    }
}
