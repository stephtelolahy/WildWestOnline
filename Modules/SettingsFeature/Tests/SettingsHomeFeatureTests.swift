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
    @Suite("Initialization")
    struct Initialization {
        @Test func initializeValues() async throws {
            // Given
            let state = SettingsHomeFeature.State()
            let sut = await Store(
                initialState: state,
                reducer: SettingsHomeFeature.reducer,
                withDependencies: {
                    $0.preferencesClient.playersCount = { 5 }
                    $0.preferencesClient.actionDelayMilliSeconds = { 500 }
                    $0.preferencesClient.isSimulationEnabled = { true }
                    $0.preferencesClient.musicVolume = { 1.0 }
                    $0.preferencesClient.preferredFigure = { "Figure1" }
                }
            )

            // When
            await sut.dispatch(.didAppear)

            // Then
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
            // Given
            let state = SettingsHomeFeature.State(playersCount: 2)
            let sut = await Store(
                initialState: state,
                reducer: SettingsHomeFeature.reducer
            )

            // When
            await sut.dispatch(.didUpdatePlayersCount(5))

            // Then
            await #expect(sut.state.playersCount == 5)
        }

        @Test func toggleSimulation() async throws {
            // Given
            let state = SettingsHomeFeature.State(simulation: true)
            let sut = await Store(
                initialState: state,
                reducer: SettingsHomeFeature.reducer
            )

            // When
            await sut.dispatch(.didToggleSimulation)

            // Then
            await #expect(sut.state.simulation == false)
        }

        @Test func updateWaitDelay() async throws {
            // Given
            let state = SettingsHomeFeature.State(actionDelayMilliSeconds: 0)
            let sut = await Store(
                initialState: state,
                reducer: SettingsHomeFeature.reducer
            )

            // When
            await sut.dispatch(.didUpdateActionDelayMilliSeconds(500))

            // Then
            await #expect(sut.state.actionDelayMilliSeconds == 500)
        }
    }
}
