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
        let state = App.State(
            screens: [.splash],
            settings: Settings.State.makeBuilder().build()
        )

        // When
        let action = App.Action.navigate(.home)
        let result = App.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home])
    }

    func test_app_whenStartedGame_shouldShowGameScreen_AndCreateGame() throws {
        // Given
        let invetory = Inventory.makeBuilder().withSample().build()
        let state = App.State(
            screens: [.home],
            settings: Settings.State.makeBuilder()
                .withInventory(invetory)
                .withPlayersCount(5)
                .build()
        )

        // When
        let action = App.Action.createGame
        let result = App.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home, .game])
        XCTAssertNotNil(result.game)
    }

    func test_app_whenFinishedGame_shouldBackToHomeScreen_AndDeleteGame() throws {
        // Given
        let state = App.State(
            screens: [.home, .game],
            settings: Settings.State.makeBuilder().build(),
            game: GameState.makeBuilder().build()
        )

        // When
        let action = App.Action.quitGame
        let result = App.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home])
        XCTAssertNil(result.game)
    }

    func test_showingSettings_shouldDisplaySettings() throws {
        // Given
        let state = App.State(
            screens: [.home],
            settings: Settings.State.makeBuilder().build()
        )

        // When
        let action = App.Action.navigate(.settings)
        let result = App.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home, .settings])
    }

    func test_closingSettings_shouldRemoveSettings() throws {
        // Given
        let state = App.State(
            screens: [.home, .settings],
            settings: Settings.State.makeBuilder().build()
        )

        // When
        let action = App.Action.close
        let result = App.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home])
    }
}
