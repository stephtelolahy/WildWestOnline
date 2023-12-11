//
//  AppFlowTests.swift
//  WildWestOnlineTests
//
//  Created by Hugues Telolahy on 02/04/2023.
//
// swiftlint:disable no_magic_numbers
@testable import App
import Game
import Redux
import Routing
import SettingsUI
import XCTest

final class AppFlowTests: XCTestCase {
    private func createAppStore(initial: AppState) -> Store<AppState> {
        Store(
            initial: initial,
            reducer: AppState.reducer
        )
    }

    func test_app_whenCompletedSplash_shouldSetHomeScreen() throws {
        // Given
        let sut = createAppStore(initial: AppState(screens: [.splash], settings: .default))

        // When
        sut.dispatch(NavAction.showScreen(.home, transition: .replace))

        // Then
        XCTAssertEqual(sut.state.screens, [.home])
    }

    func test_app_whenStartedGame_shouldShowGameScreen_AndCreateGame() throws {
        // Given
        let sut = createAppStore(initial: AppState(screens: [.home], settings: .default))

        // When
        sut.dispatch(NavAction.showScreen(.game))

        // Then
        XCTAssertEqual(sut.state.screens.last, .game)
        XCTAssertNotNil(sut.state.game)
    }

    func test_app_whenFinishedGame_shouldBackToHomeScreen_AndDeleteGame() throws {
        // Given
        let sut = createAppStore(
            initial: AppState(
                screens: [
                    .home,
                    .game
                ],
                settings: .default,
                game: GameState.makeBuilder().build()
            )
        )

        // When'
        sut.dispatch(NavAction.dismiss)

        // Then
        XCTAssertEqual(sut.state.screens.last, .home)
        XCTAssertNil(sut.state.game)
    }
}

private extension SettingsState {
    static let `default`: Self = .init(playersCount: 5, simulation: false)
}
