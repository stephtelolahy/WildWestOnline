//
//  AppFlowTests.swift
//  WildWestOnlineTests
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable no_magic_numbers
@testable import App
import Game
import GameUI
import HomeUI
import Redux
import SettingsUI
import SplashUI
import XCTest

final class AppFlowTests: XCTestCase {
    func test_app_whenCompletedSplash_shouldSetHomeScreen() throws {
        // Given
        let state = AppState(screen: .splash, settings: .sample)

        // When
        let action = SplashAction.finish
        let result = AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screen, .home)
    }

    func test_app_whenStartedGame_shouldShowGameScreen_AndCreateGame() throws {
        // Given
        let state = AppState(screen: .home, settings: .sample)

        // When
        let action = HomeAction.play
        let result = AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screen, .game)
        XCTAssertNotNil(result.game)
    }

    func test_app_whenFinishedGame_shouldBackToHomeScreen_AndDeleteGame() throws {
        // Given
        let state = AppState(
            screen: .game,
            settings: .sample,
            game: GameState.makeBuilder().build()
        )

        // When
        let action = GamePlayAction.quit
        let result = AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screen, .home)
        XCTAssertNil(result.game)
    }
}

private extension SettingsState {
    static let sample: Self = .init(
        playersCount: 5,
        waitDelayMilliseconds: 0,
        simulation: false
    )
}
