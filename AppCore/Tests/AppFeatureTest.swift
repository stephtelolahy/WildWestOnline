//
//  AppFeatureTest.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//

import Testing
import AppCore
import GameCore
import Redux
import SettingsCore

struct AppFeatureTest {
    private func createAppStore(initialState: AppFeature.State) async -> AppStore {
        await .init(
            initialState: initialState,
            reducer: AppFeature.reducer,
            dependencies: .init(
                settings: .empty(),
                audioPlayer: .init()
            )
        )
    }

    @Test func app_whenStartedGame_shouldShowGameScreen_AndCreateGame() async throws {
        // Given
        let state = AppFeature.State(
            inventory: Inventory.makeBuilder().withSample().build(),
            navigation: .init(),
            settings: SettingsFeature.State.makeBuilder().withPlayersCount(5).build()
        )
        let sut = await createAppStore(initialState: state)

        // When
        let action = AppFeature.Action.start
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.navigation.path == [.game])
        await #expect(sut.state.game != nil)
    }
    
    @Test func app_whenFinishedGame_shouldBackToHomeScreen_AndDeleteGame() async throws {
        // Given
        let state = AppFeature.State(
            inventory: Inventory.makeBuilder().build(),
            navigation: .init(path: [.game]),
            settings: SettingsFeature.State.makeBuilder().build(),
            game: GameFeature.State.makeBuilder().build()
        )
        let sut = await createAppStore(initialState: state)

        // When
        let action = AppFeature.Action.quit
        await sut.dispatch(action)

        // Then
        await #expect(sut.state.navigation.path.isEmpty)
        await #expect(sut.state.game == nil)
    }
}
