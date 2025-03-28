//
//  AppCoreTest.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//

import AppCore
import GameCore
import Redux
import SettingsCore
import Testing

struct AppCoreTest {
    @Test func app_whenStartedGame_shouldShowGameScreen_AndCreateGame() async throws {
        // Given
        let state = AppState(
            navigation: .init(mainStack: .init(path: [.home])),
            settings: SettingsFeature.State.makeBuilder().withPlayersCount(5).build(),
            inventory: Inventory.makeBuilder().withSample().build()
        )
        let sut = await createAppStore(initialState: state)

        // When
        let action = SetupGameAction.startGame
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.navigation.mainStack.path == [.home, .game])
        await #expect(sut.state.game != nil)
    }

    @Test func app_whenFinishedGame_shouldBackToHomeScreen_AndDeleteGame() async throws {
        // Given
        let state = AppState(
            navigation: .init(mainStack: .init(path: [.home, .game])),
            settings: SettingsFeature.State.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build(),
            game: GameState.makeBuilder().build()
        )
        let sut = await createAppStore(initialState: state)

        // When
        let action = SetupGameAction.quitGame
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.navigation.mainStack.path == [.home])
        await #expect(sut.state.game == nil)
    }
}

private typealias AppStore = Store<AppState, AppDependencies>

@MainActor private func createAppStore(initialState: AppState) -> AppStore {
    .init(
        initialState: initialState,
        reducer: appReducer,
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
