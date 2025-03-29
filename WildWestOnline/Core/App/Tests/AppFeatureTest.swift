//
//  AppFeatureTest.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//

import AppCore
import GameCore
import Redux
import SettingsCore
import Testing

struct AppFeatureTest {
    private typealias AppStore = Store<AppFeature.State, AppFeature.Dependencies>

    @MainActor private func createAppStore(initialState: AppFeature.State) -> AppStore {
        .init(
            initialState: initialState,
            reducer: AppFeature.reduce,
            dependencies: .init(
                settings: .init(
                    savePlayersCount: { _ in },
                    saveActionDelayMilliSeconds: { _ in },
                    saveSimulationEnabled: { _ in },
                    savePreferredFigure: { _ in }
                )
            )
        )
    }

    @Test func app_whenStartedGame_shouldShowGameScreen_AndCreateGame() async throws {
        // Given
        let state = AppFeature.State(
            navigation: .init(path: [.home]),
            settings: SettingsFeature.State.makeBuilder().withPlayersCount(5).build(),
            inventory: Inventory.makeBuilder().withSample().build()
        )
        let sut = await createAppStore(initialState: state)

        // When
        let action = GameSessionFeature.Action.start
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.navigation.path == [.home, .game])
        await #expect(sut.state.game != nil)
    }

    @Test func app_whenFinishedGame_shouldBackToHomeScreen_AndDeleteGame() async throws {
        // Given
        let state = AppFeature.State(
            navigation: .init(path: [.home, .game]),
            settings: SettingsFeature.State.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build(),
            game: GameFeature.State.makeBuilder().build()
        )
        let sut = await createAppStore(initialState: state)

        // When
        let action = GameSessionFeature.Action.quit
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.navigation.path == [.home])
        await #expect(sut.state.game == nil)
    }
}
