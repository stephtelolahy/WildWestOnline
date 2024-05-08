//
//  AppCoreTests.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 23/02/2024.
//
// swiftlint:disable no_magic_numbers

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
            settings: SettingsState.makeBuilder().build()
        )

        // When
        let action = AppAction.navigate(.home)
        let result = AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home])
    }

    func test_app_whenStartedGame_shouldShowGameScreen_AndCreateGame() throws {
        // Given
        let invetory = Inventory.makeBuilder().build()
        let state = AppState(
            screens: [.home],
            settings: SettingsState.makeBuilder().withInventory(invetory).build()
        )

        // When
        let action = AppAction.navigate(.game)
        let result = AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home, .game])
        XCTAssertNotNil(result.game)
    }

    func test_app_whenFinishedGame_shouldBackToHomeScreen_AndDeleteGame() throws {
        // Given
        let state = AppState(
            screens: [.home, .game],
            settings: SettingsState.makeBuilder().build(),
            game: GameState.makeBuilder().build()
        )

        // When
        let action = AppAction.close
        let result = AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home])
        XCTAssertNil(result.game)
    }

    func test_showingSettings_shouldDisplaySettings() throws {
        // Given
        let state = AppState(
            screens: [.home],
            settings: SettingsState.makeBuilder().build()
        )

        // When
        let action = AppAction.navigate(.settings)
        let result = AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home, .settings])
    }

    func test_closingSettings_shouldRemoveSettings() throws {
        // Given
        let state = AppState(
            screens: [.home, .settings],
            settings: SettingsState.makeBuilder().build()
        )

        // When
        let action = AppAction.close
        let result = AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home])
    }
}
