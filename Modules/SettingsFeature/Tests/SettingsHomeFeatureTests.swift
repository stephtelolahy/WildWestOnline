//
//  SettingsHomeFeatureTests.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//

import Testing
import Redux
@testable import SettingsFeature
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
        let state = SettingsHomeFeature.State.create(playersCount: 2)
        let sut = await createSettingsStore(initialState: state)

        // When
        let action = SettingsHomeFeature.Action.updatePlayersCount(5)
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.playersCount == 5)
    }

    @Test func toggleSimulation() async throws {
        // Given
        let state = SettingsHomeFeature.State.create(simulation: true)
        let sut = await createSettingsStore(initialState: state)

        // When
        let action = SettingsHomeFeature.Action.toggleSimulation
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.simulation == false)
    }

    @Test func updateWaitDelay() async throws {
        // Given
        let state = SettingsHomeFeature.State.create(actionDelayMilliSeconds: 0)
        let sut = await createSettingsStore(initialState: state)

        // When
        let action = SettingsHomeFeature.Action.updateActionDelayMilliSeconds(500)
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.actionDelayMilliSeconds == 500)
    }
}

extension SettingsHomeFeature.State {
    static func create(
        playersCount: Int = 0,
        actionDelayMilliSeconds: Int = 0,
        simulation: Bool = false,
        preferredFigure: String? = nil,
        musicVolume: Float = 0
    ) -> Self {
        .init(
            playersCount: playersCount,
            actionDelayMilliSeconds: actionDelayMilliSeconds,
            simulation: simulation,
            preferredFigure: preferredFigure,
            musicVolume: musicVolume
        )
    }
}
