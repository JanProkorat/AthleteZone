//
//  SettingsViewModelTests.swift
//  Athlete Zone Tests
//
//  Created by Jan Prokorát on 22.07.2023.
//

@testable import Athlete_Zone
import Nimble
import XCTest

class SettingsViewModelTests: XCTestCase {
    var viewModel: SettingsViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()

        // Create the mock instance and inject it into the SettingsViewModel
        viewModel = SettingsViewModel()
        viewModel.connectivityManager = WatchConnectivityMock()
    }

    override func tearDownWithError() throws {
        viewModel = nil
        try super.tearDownWithError()
    }

    func testShareLanguage() {
        // Test sharing a language
        viewModel.connectivityManager.lastSentMessage = nil
        let languageToShare: Language = .en
        viewModel.shareLanguage(languageToShare)

        // Assert that the language value was sent to the mock connectivity manager using Nimble's expect and to syntax
        expect(self.viewModel.connectivityManager.lastSentMessage?[DefaultItem.language.rawValue] as? String).to(equal(languageToShare.rawValue))
    }

    func testShareSoundsEnabled() {
        // Test sharing sounds enabled status
        let soundsEnabled = true
        viewModel.shareSoundsEnabled(soundsEnabled)

        // Assert that the sounds enabled value was sent to the mock connectivity manager using Nimble's expect and to syntax
        expect(self.viewModel.connectivityManager.lastSentMessage?[DefaultItem.soundsEnabled.rawValue] as? Bool).to(equal(soundsEnabled))
    }

    func testShareHapticsEnabled() {
        // Test sharing haptics enabled status
        let hapticsEnabled = true
        viewModel.shareHapticsEnabled(hapticsEnabled)

        // Assert that the haptics enabled value was sent to the mock connectivity manager using Nimble's expect and to syntax
        expect(self.viewModel.connectivityManager.lastSentMessage?[DefaultItem.hapticsEnabled.rawValue] as? Bool).to(equal(hapticsEnabled))
    }
}
