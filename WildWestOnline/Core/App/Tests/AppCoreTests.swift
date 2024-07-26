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
            screens: [.home],
            settings: SettingsState.makeBuilder().withPlayersCount(5).build(),
            inventory: Inventory.makeBuilder().withSample().build()
        )

        // When
        let action = GameSetupAction.start
        let result = try AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home, .game])
        XCTAssertNotNil(result.game)
    }

    func test_app_whenFinishedGame_shouldBackToHomeScreen_AndDeleteGame() throws {
        // Given
        let state = AppState(
            screens: [.home, .game],
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build(),
            game: GameState.makeBuilder().build()
        )

        // When
        let action = GameSetupAction.quit
        let result = try AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home])
        XCTAssertNil(result.game)
    }
}
