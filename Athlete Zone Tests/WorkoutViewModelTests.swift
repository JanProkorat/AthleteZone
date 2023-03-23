//
//  WorkoutViewModelTests.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 08.03.2023.
//

@testable import Athlete_Zone
import Nimble
import XCTest

final class WorkoutViewModelTests: XCTestCase {
    var viewModel: WorkOutViewModel!
    var realmManager: WorkOutRealmManagerProtocol?

    override func setUp() {
        super.setUp()
        viewModel = WorkOutViewModel()
        realmManager = WorkOutRealmManagerMock()
        viewModel.realmManager = realmManager
    }

    override func tearDown() {
        viewModel = nil
        realmManager = nil
    }

    func testInit() {
        expect(self.viewModel.name).to(equal("Title"))
        expect(self.viewModel.work).to(equal(30))
        expect(self.viewModel.rest).to(equal(60))
        expect(self.viewModel.series).to(equal(3))
        expect(self.viewModel.rounds).to(equal(5))
        expect(self.viewModel.reset).to(equal(60))
    }

    func testIsValid() {
        expect(self.viewModel.isValid).to(beTrue())

        viewModel.name = ""
        expect(self.viewModel.isValid).to(beFalse())

        viewModel.name = "Title"
        viewModel.work = 0
        expect(self.viewModel.isValid).to(beFalse())

        viewModel.work = 30
        viewModel.rest = 0
        expect(self.viewModel.isValid).to(beFalse())

        viewModel.rest = 60
        viewModel.series = 0
        expect(self.viewModel.isValid).to(beFalse())

        viewModel.series = 3
        viewModel.rounds = 0
        expect(self.viewModel.isValid).to(beFalse())

        viewModel.rounds = 5
        viewModel.reset = 0
        expect(self.viewModel.isValid).to(beFalse())
    }

    func testTimeOverview() {
        expect(self.viewModel.timeOverview).to(equal(1290))

        viewModel.work = 60
        expect(self.viewModel.timeOverview).to(equal(1740))

        viewModel.reset = 30
        expect(self.viewModel.timeOverview).to(equal(1620))

        viewModel.rounds = 3
        expect(self.viewModel.timeOverview).to(equal(960))

        viewModel.series = 2
        expect(self.viewModel.timeOverview).to(equal(600))

        viewModel.rest = 15
        expect(self.viewModel.timeOverview).to(equal(465))
    }

    func testGetProperty() {
        expect(self.viewModel.getProperty(for: .work)).to(equal(30))
        expect(self.viewModel.getProperty(for: .rest)).to(equal(60))
        expect(self.viewModel.getProperty(for: .series)).to(equal(3))
        expect(self.viewModel.getProperty(for: .rounds)).to(equal(5))
        expect(self.viewModel.getProperty(for: .reset)).to(equal(60))
    }

    func testLoad() {
        let data = WorkOut()
        viewModel.realmManager!.add(data)
        viewModel.loadWorkoutById(data._id.stringValue)
        expect(data._id.stringValue).to(equal(viewModel._id))
    }
}
