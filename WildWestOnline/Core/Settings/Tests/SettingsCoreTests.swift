//
//  SettingsCoreTests.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//

import SettingsCore
import Testing

struct SettingsCoreTests {
    @Test func updatePlayersCount() async throws {
        // Given
        let state = SettingsState.makeBuilder().withPlayersCount(2).build()

        // When
        let action = SettingsAction.updatePlayersCount(5)
        let result = try SettingsState.reducer(state, action)

        // Then
        #expect(result.playersCount == 5)
    }

    @Test func toggleSimulation() async throws {
        // Given
        let state = SettingsState.makeBuilder().withSimulation(true).build()

        // When
        let action = SettingsAction.toggleSimulation
        let result = try SettingsState.reducer(state, action)

        // Then
        #expect(!result.simulation)
    }

    @Test func updateWaitDelay() async throws {
        // Given
        let state = SettingsState.makeBuilder().withWaitDelaySeconds(0).build()

        // When
        let action = SettingsAction.updateWaitDelaySeconds(500)
        let result = try SettingsState.reducer(state, action)

        // Then
        #expect(result.waitDelaySeconds == 500)
    }
}
