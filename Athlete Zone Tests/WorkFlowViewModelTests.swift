//
//  WorkFlowViewModelTests.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 17.03.2023.
//

@testable import Athlete_Zone
import Nimble
import XCTest

class WorkFlowViewModelTests: XCTestCase {
    var viewModel: WorkFlowViewModel!

    override func setUpWithError() throws {
        viewModel = WorkFlowViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testCreateWorkFlow() throws {
        viewModel.createWorkFlow("Test WorkFlow", 10, 5, 3, 2, 60)

        expect(self.viewModel.flow.count).to(equal(12))
        expect(self.viewModel.flow.first?.type).to(equal(.preparation))
        expect(self.viewModel.flow.last?.type).to(equal(.work))
        expect(self.viewModel.flow.last?.round).to(equal(2))
        expect(self.viewModel.flow.last?.serie).to(equal(3))
    }

    func testIsLastRunning() throws {
        viewModel.createWorkFlow("Test WorkFlow", 10, 5, 3, 2, 60)
        expect(self.viewModel.isLastRunning).to(beFalse())

        viewModel.selectedFlow = viewModel.flow.last
        viewModel.roundsCount = viewModel.selectedFlow?.round ?? 0
        viewModel.seriesCount = viewModel.selectedFlow?.serie ?? 0
        expect(self.viewModel.isLastRunning).to(beTrue())
    }

    func testUpdateInterval() throws {
        viewModel.createWorkFlow("Test WorkFlow", 10, 5, 3, 2, 60)
        viewModel.selectedFlow = viewModel.flow.first
        viewModel.updateInterval()
        expect(self.viewModel.selectedFlow?.interval).to(equal(9))

        viewModel.updateInterval()
        expect(self.viewModel.selectedFlowIndex).to(equal(0))
    }

    func testUpdateFlowOnIndexChange() throws {
        viewModel.createWorkFlow("Test WorkFlow", 10, 5, 3, 2, 60)
        viewModel.updateFlowOnIndexChange(0)
        expect(self.viewModel.selectedFlow).to(equal(viewModel.flow.first))

        viewModel.updateFlowOnIndexChange(viewModel.flow.count)
        expect(self.viewModel.state).to(equal(.ready))
    }

    func testUpdateTimerOnStateChange() throws {
        viewModel.setState(.running)
        expect(self.viewModel.timer).toNot(beNil())
        viewModel.setState(.paused)
        expect(self.viewModel.timer?.isValid).to(beFalse())
    }
}
