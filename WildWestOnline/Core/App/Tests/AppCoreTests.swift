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
    func test_app_whenCompletedSplash_shouldSetHomeScreen() throws {
        // Given
        let state = AppState(
            screens: [.splash],
            settings: SettingsState.makeBuilder().build(),
            inventory: InventoryState.makeBuilder().build()
        )

        // When
        let action = AppAction.navigate(.home)
        let result = try AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home])
    }

    func test_app_whenStartedGame_shouldShowGameScreen_AndCreateGame() throws {
        // Given
        let state = AppState(
            screens: [.home],
            settings: SettingsState.makeBuilder().withPlayersCount(5).build(),
            inventory: InventoryState.makeBuilder().withSample().build()
        )

        // When
        let action = AppAction.startGame
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
            inventory: InventoryState.makeBuilder().build(),
            game: GameState.makeBuilder().build()
        )

        // When
        let action = AppAction.exitGame
        let result = try AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home])
        XCTAssertNil(result.game)
    }

    func test_showingSettings_shouldDisplaySettings() throws {
        // Given
        let state = AppState(
            screens: [.home],
            settings: SettingsState.makeBuilder().build(),
            inventory: InventoryState.makeBuilder().build()
        )

        // When
        let action = AppAction.navigate(.settings)
        let result = try AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home, .settings])
    }

    func test_closingSettings_shouldRemoveSettings() throws {
        // Given
        let state = AppState(
            screens: [.home, .settings],
            settings: SettingsState.makeBuilder().build(),
            inventory: InventoryState.makeBuilder().build()
        )

        // When
        let action = AppAction.close
        let result = try AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home])
    }
}
