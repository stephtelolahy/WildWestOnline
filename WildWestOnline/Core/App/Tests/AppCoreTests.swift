//
//  AppCoreTests.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//

import AppCore
import GameCore
import Redux
import SettingsCore
import XCTest

final class AppCoreTests: XCTestCase {
    func test_app_whenStartedGame_shouldShowGameScreen_AndCreateGame() throws {
        // Given
        let state = AppState(
            navigation: .init(root: .init(path: [.home])),
            settings: SettingsState.makeBuilder().withPlayersCount(5).build(),
            inventory: Inventory.makeBuilder().withSample().build()
        )
        let sut = Store<AppState>(
            initial: state,
            reducer: AppState.reducer,
            middlewares: [Middlewares.gameSetup()]
        )

        // When
        let action = GameSetupAction.startGame
        sut.dispatch(action)
        let result = sut.state

        // Then
        XCTAssertEqual(result.navigation.main.path, [.home, .game])
        XCTAssertNotNil(result.game)
    }

    func test_app_whenFinishedGame_shouldBackToHomeScreen_AndDeleteGame() throws {
        // Given
        let state = AppState(
            navigation: .init(root: .init(path: [.home, .game])),
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build(),
            game: GameState.makeBuilder().build()
        )
        let sut = Store<AppState>(
            initial: state,
            reducer: AppState.reducer,
            middlewares: [Middlewares.gameSetup()]
        )

        // When
        let action = GameSetupAction.quitGame
        sut.dispatch(action)
        let result = sut.state

        // Then
        XCTAssertEqual(result.navigation.main.path, [.home])
        XCTAssertNil(result.game)
    }
}
