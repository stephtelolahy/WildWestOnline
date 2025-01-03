//
//  SettingsCoreTest.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//

import Testing
import SettingsCore
import Redux

struct SettingsCoreTests {
    @Test func updatePlayersCount() async throws {
        // Given
        let state = SettingsState.makeBuilder().withPlayersCount(2).build()
        let sut = await createSettingsStore(initialState: state)

        // When
        let action = SettingsAction.updatePlayersCount(5)
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.playersCount == 5)
    }

    @Test func toggleSimulation() async throws {
        // Given
        let state = SettingsState.makeBuilder().withSimulation(true).build()
        let sut = await createSettingsStore(initialState: state)

        // When
        let action = SettingsAction.toggleSimulation
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.simulation == false)
    }

    @Test func updateWaitDelay() async throws {
        // Given
        let state = SettingsState.makeBuilder().withActionDelayMilliSeconds(0).build()
        let sut = await createSettingsStore(initialState: state)

        // When
        let action = SettingsAction.updateActionDelayMilliSeconds(500)
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.actionDelayMilliSeconds == 500)
    }
}

private typealias SettingsStore = Store<SettingsState, SettingsAction, SettingsDependencies>

@MainActor private func createSettingsStore(initialState: SettingsState) -> SettingsStore {
    .init(
        initialState: initialState,
        reducer: settingsReducer,
        dependencies: .init(
            setPlayersCount: { _ in },
            setActionDelayMilliSeconds: { _ in },
            setSimulationEnabled: { _ in },
            setPreferredFigure: { _ in }
        )
    )
}
