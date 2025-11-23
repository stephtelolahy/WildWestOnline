//
//  AppFeatureTest.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//

import Testing
import AppFeature
import GameFeature
import Redux
import SettingsFeature

struct AppFeatureTest {
    private func createAppStore(initialState: AppFeature.State) async -> AppStore {
        await .init(
            initialState: initialState,
            reducer: AppFeature.reducer,
            dependencies: .init(
                settingsClient: .empty(),
                audioClient: .empty(),
                gameDependencies: .init(registry: .init(handlers: []))
            )
        )
    }

    @Test func app_whenStartedGame_shouldShowGameScreen_AndCreateGame() async throws {
        // Given
        let cards = (1...100).map {
            Card(
                name: "c\($0)",
                type: .figure,
                effects: [
                    .init(
                        trigger: .permanent,
                        action: .setMaxHealth,
                        amount: 1
                    )
                ]
            )
        }
        let state = AppFeature.State(
            cardLibrary: .init(cards: cards),
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
            cardLibrary: .init(),
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
