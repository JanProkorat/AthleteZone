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
    var realmManager: WorkOutRealmManagerProtocol!

    override func setUp() {
        viewModel = LibraryViewModel()
        realmManager = WorkOutRealmManagerMock()
        viewModel.realmManager = realmManager
    }

    override func tearDown() {
        viewModel = nil
        realmManager = nil
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

    func testRemoveWorkout() {
        let workout = WorkOut()
        viewModel.realmManager.add(workout)
        viewModel.setSelectedWorkOut(workout)
        viewModel.removeWorkout(workout)
        expect(self.viewModel.selectedWorkoutManager.selectedWorkout).to(beNil())

        let data = viewModel.realmManager.load()
        let identical = data.first(where: { $0._id == workout._id })
        expect(identical).to(beNil())
    }
}
