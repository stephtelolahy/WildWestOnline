//
//  SettingsHomeFeatureTest.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//

import Testing
import Redux
import SettingsFeature
import PreferencesClient

struct SettingsHomeFeatureTests {
    private typealias SettingsStore = Store<SettingsHomeFeature.State, SettingsHomeFeature.Action>

    private func createSettingsStore(initialState: SettingsHomeFeature.State) async -> SettingsStore {
        await .init(
            initialState: initialState,
            reducer: SettingsHomeFeature.reducer
        )
    }

    @Test func updatePlayersCount() async throws {
        // Given
        let state = SettingsHomeFeature.State.makeBuilder().withPlayersCount(2).build()
        let sut = await createSettingsStore(initialState: state)

        // When
        let action = SettingsHomeFeature.Action.updatePlayersCount(5)
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.playersCount == 5)
    }

    @Test func toggleSimulation() async throws {
        // Given
        let state = SettingsHomeFeature.State.makeBuilder().withSimulation(true).build()
        let sut = await createSettingsStore(initialState: state)

        // When
        let action = SettingsHomeFeature.Action.toggleSimulation
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.simulation == false)
    }

    @Test func updateWaitDelay() async throws {
        // Given
        let state = SettingsHomeFeature.State.makeBuilder().withActionDelayMilliSeconds(0).build()
        let sut = await createSettingsStore(initialState: state)

        // When
        let action = SettingsHomeFeature.Action.updateActionDelayMilliSeconds(500)
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.actionDelayMilliSeconds == 500)
    }
}
