//
//  SettingsCoreTests.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//

import SettingsCore
import XCTest

final class SettingsCoreTests: XCTestCase {
    func test_updatePlayersCount() throws {
        // Given
        let state = SettingsState.makeBuilder().withPlayersCount(2).build()

        // When
        let action = SettingsAction.updatePlayersCount(5)
        let result = SettingsState.reducer(state, action)

        // Then
        XCTAssertEqual(result.playersCount, 5)
    }

    func test_toggleSimulation() throws {
        // Given
        let state = SettingsState.makeBuilder().withSimulation(true).build()

        // When
        let action = SettingsAction.toggleSimulation
        let result = SettingsState.reducer(state, action)

        // Then
        XCTAssertFalse(result.simulation)
    }

    func test_updateWaitDelay() throws {
        // Given
        let state = SettingsState.makeBuilder().withWaitDelayMilliseconds(0).build()

        // When
        let action = SettingsAction.updateWaitDelayMilliseconds(500)
        let result = SettingsState.reducer(state, action)

        // Then
        XCTAssertEqual(result.waitDelayMilliseconds, 500)
    }
}