//
//  WorkOutEditViewModelTests.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 18.03.2023.
//

@testable import Athlete_Zone
import Nimble
import XCTest

class WorkOutEditViewModelTests: XCTestCase {
    var viewModel: WorkOutEditViewModel!
    var realmManager: WorkOutRealmManagerProtocol!

    override func setUp() {
        viewModel = WorkOutEditViewModel()
        realmManager = WorkOutRealmManagerMock()
    }

    override func tearDown() {
        viewModel = nil
        realmManager = nil
    }

    func testSaveNewWorkOut() {
        viewModel.name = "Test WorkOut"
        viewModel.work = 30
        viewModel.rest = 10
        viewModel.series = 5
        viewModel.rounds = 3
        viewModel.reset = 60

        viewModel.save()

        expect(self.viewModel._id).toNot(beNil())
    }

    func testUpdateWorkOut() {
        viewModel.name = "Test WorkOut"
        viewModel.work = 30
        viewModel.rest = 10
        viewModel.series = 5
        viewModel.rounds = 3
        viewModel.reset = 60

        viewModel.save()

        let id = viewModel._id!
        let work = 45
        let rest = 25
        viewModel.work = work
        viewModel.rest = rest

        viewModel.save()

        let workout = viewModel.realmManager.load(primaryKey: id)
        expect(workout).toNot(beNil())

        if let object = workout {
            expect(object.work).to(equal(work))
            expect(object.rest).to(equal(rest))
        }
    }
}
