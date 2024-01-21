//
//  AppFlowTests.swift
//  WildWestOnlineTests
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable no_magic_numbers
@testable import App
import Game
import Navigation
import Redux
import SettingsUI
import XCTest

final class AppFlowTests: XCTestCase {
    func test_app_whenCompletedSplash_shouldSetHomeScreen() throws {
        // Given
        let state = AppState(screens: [.splash], settings: .default)

        // When
        let action = NavAction.showScreen(.home, transition: .replace)
        let result = AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home])
    }

    func test_app_whenStartedGame_shouldShowGameScreen_AndCreateGame() throws {
        // Given
        let state = AppState(screens: [.home], settings: .default)

        // When
        let action = NavAction.showScreen(.game)
        let result = AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens.last, .game)
        XCTAssertNotNil(result.game)
    }

    func test_app_whenFinishedGame_shouldBackToHomeScreen_AndDeleteGame() throws {
        // Given
        let state = AppState(
            screens: [
                .home,
                .game
            ],
            settings: .default,
            game: GameState.makeBuilder().build()
        )

        // When
        let action = NavAction.dismiss
        let result = AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens.last, .home)
        XCTAssertNil(result.game)
    }
}

private extension SettingsState {
    static let `default`: Self = .init(playersCount: 5, simulation: false)
}
