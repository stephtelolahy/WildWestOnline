//
//  SettingsCoreTest.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//

import Testing
import SettingsCore
import Redux

struct SettingsFeatureTests {
    private typealias SettingsStore = Store<SettingsFeature.State, SettingsFeature.Dependencies>

    @MainActor private func createSettingsStore(initialState: SettingsFeature.State) -> SettingsStore {
        .init(
            initialState: initialState,
            reducer: SettingsFeature.reduce,
            dependencies: .init()
        )
    }

    @Test func updatePlayersCount() async throws {
        // Given
        let state = SettingsFeature.State.makeBuilder().withPlayersCount(2).build()
        let sut = await createSettingsStore(initialState: state)

        // When
        let action = SettingsFeature.Action.updatePlayersCount(5)
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.playersCount == 5)
    }

    @Test func toggleSimulation() async throws {
        // Given
        let state = SettingsFeature.State.makeBuilder().withSimulation(true).build()
        let sut = await createSettingsStore(initialState: state)

        // When
        let action = SettingsFeature.Action.toggleSimulation
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.simulation == false)
    }

    @Test func updateWaitDelay() async throws {
        // Given
        let state = SettingsFeature.State.makeBuilder().withActionDelayMilliSeconds(0).build()
        let sut = await createSettingsStore(initialState: state)

        // When
        let action = SettingsFeature.Action.updateActionDelayMilliSeconds(500)
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.actionDelayMilliSeconds == 500)
    }
}
