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
        let sut = await SettingsStore(
            initialState: state,
            reducer: settingsReducer,
            dependencies: SettingsServiceMock()
        )

        // When
        let action = SettingsAction.updatePlayersCount(5)
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.playersCount == 5)
    }

    @Test func toggleSimulation() async throws {
        // Given
        let state = SettingsState.makeBuilder().withSimulation(true).build()
        let sut = await SettingsStore(
            initialState: state,
            reducer: settingsReducer,
            dependencies: SettingsServiceMock()
        )

        // When
        let action = SettingsAction.toggleSimulation
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.simulation == false)
    }

    @Test func updateWaitDelay() async throws {
        // Given
        let state = SettingsState.makeBuilder().withActionDelayMilliSeconds(0).build()
        let sut = await SettingsStore(
            initialState: state,
            reducer: settingsReducer,
            dependencies: SettingsServiceMock()
        )

        // When
        let action = SettingsAction.updateActionDelayMilliSeconds(500)
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.actionDelayMilliSeconds == 500)
    }
}

typealias SettingsStore = Store<SettingsState, SettingsAction, SettingsService>

struct SettingsServiceMock: SettingsService {
    func playersCount() -> Int {
        0
    }

    func setPlayersCount(_ value: Int) {
    }

    func actionDelayMilliSeconds() -> Int {
        0
    }

    func setActionDelayMilliSeconds(_ value: Int) {
    }

    func isSimulationEnabled() -> Bool {
        false
    }

    func setSimulationEnabled(_ value: Bool) {
    }

    func preferredFigure() -> String? {
        nil
    }

    func setPreferredFigure(_ value: String?) {
    }
}
