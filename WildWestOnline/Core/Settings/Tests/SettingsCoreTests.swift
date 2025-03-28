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
        let state = Settings.State.makeBuilder().withPlayersCount(2).build()
        let sut = await createSettingsStore(initialState: state)

        // When
        let action = Settings.Action.updatePlayersCount(5)
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.playersCount == 5)
    }

    @Test func toggleSimulation() async throws {
        // Given
        let state = Settings.State.makeBuilder().withSimulation(true).build()
        let sut = await createSettingsStore(initialState: state)

        // When
        let action = Settings.Action.toggleSimulation
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.simulation == false)
    }

    @Test func updateWaitDelay() async throws {
        // Given
        let state = Settings.State.makeBuilder().withActionDelayMilliSeconds(0).build()
        let sut = await createSettingsStore(initialState: state)

        // When
        let action = Settings.Action.updateActionDelayMilliSeconds(500)
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.actionDelayMilliSeconds == 500)
    }
}

private typealias SettingsStore = Store<Settings.State, Settings.Dependencies>

@MainActor private func createSettingsStore(initialState: Settings.State) -> SettingsStore {
    .init(
        initialState: initialState,
        reducer: Settings.reducer,
        dependencies: .init()
    )
}
