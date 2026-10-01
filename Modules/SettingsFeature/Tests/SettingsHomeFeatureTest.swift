//
//  SettingsHomeFeatureTest.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//

import Testing
import Redux
@testable import SettingsFeature
import PreferencesClient

enum SettingsHomeFeatureTest {
    @Suite("Initialization")
    struct Initialization {
        @Test func initializeValues() async throws {
            let sut = await Store(
                initialState: SettingsHomeFeature.State(),
                reducer: SettingsHomeFeature.reducer,
                withDependencies: {
                    $0.preferencesClient.playersCount = { 5 }
                    $0.preferencesClient.actionDelayMilliSeconds = { 500 }
                    $0.preferencesClient.isSimulationEnabled = { true }
                    $0.preferencesClient.musicVolume = { 1.0 }
                    $0.preferencesClient.preferredFigure = { "Figure1" }
                }
            )

            await sut.dispatch(.didAppear)

            await #expect(sut.state.playersCount == 5)
            await #expect(sut.state.actionDelayMilliSeconds == 500)
            await #expect(sut.state.simulation == true)
            await #expect(sut.state.musicVolume == 1)
            await #expect(sut.state.preferredFigure == "Figure1")
        }
    }

    @Suite("Editing preferences")
    struct EditingPreferences {
        @Test func updatePlayersCount() async throws {
            let sut = await Store(
                initialState: SettingsHomeFeature.State(playersCount: 2),
                reducer: SettingsHomeFeature.reducer
            )

            await sut.dispatch(.didUpdatePlayersCount(5))

            await #expect(sut.state.playersCount == 5)
        }

        @Test func toggleSimulation() async throws {
            let sut = await Store(
                initialState: SettingsHomeFeature.State(simulation: true),
                reducer: SettingsHomeFeature.reducer
            )

            await sut.dispatch(.didToggleSimulation)

            await #expect(sut.state.simulation == false)
        }

        @Test func updateWaitDelay() async throws {
            let sut = await Store(
                initialState: SettingsHomeFeature.State(actionDelayMilliSeconds: 0),
                reducer: SettingsHomeFeature.reducer
            )

            await sut.dispatch(.didUpdateActionDelayMilliSeconds(500))

            await #expect(sut.state.actionDelayMilliSeconds == 500)
        }
    }
}
