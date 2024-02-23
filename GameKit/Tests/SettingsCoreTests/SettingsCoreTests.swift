//
//  SettingsCoreTests.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//
// swiftlint:disable no_magic_numbers

import SettingsCore
import XCTest

final class SettingsCoreTests: XCTestCase {
    func test_updatePlayersCount() throws {
        // Given
        let state = Settings(playersCount: 2)

        // When
        let action = SettingsAction.updatePlayersCount(5)
        let result = Settings.reducer(state, action)

        // Then
        XCTAssertEqual(result.playersCount, 5)
    }

    func test_toggleSimulation() throws {
        // Given
        let state = Settings(playersCount: 3, simulation: false)

        // When
        let action = SettingsAction.toggleSimulation
        let result = Settings.reducer(state, action)

        // Then
        XCTAssertTrue(result.simulation)
    }

    func test_updateWaitDelay() throws {
        // Given
        let state = Settings(playersCount: 3, waitDelayMilliseconds: 0)

        // When
        let action = SettingsAction.updateWaitDelayMilliseconds(500)
        let result = Settings.reducer(state, action)

        // Then
        XCTAssertEqual(result.waitDelayMilliseconds, 500)
    }
}
