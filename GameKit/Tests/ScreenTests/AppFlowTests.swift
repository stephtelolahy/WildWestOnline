//
//  AppFlowTests.swift
//  WildWestOnlineTests
//
//  Created by Hugues Telolahy on 02/04/2023.
//
import Game
import Redux
@testable import Screen
import XCTest

final class AppFlowTests: XCTestCase {
    private func createAppStore(initial: AppState) -> Store<AppState> {
        Store(
            initial: initial,
            reducer: AppState.reducer,
            middlewares: []
        )
    }

    func test_app_initially_shouldShowSplashScreen() {
        // Given
        // When
        let sut = createAppStore(initial: AppState())

        // Then
        XCTAssertEqual(sut.state.screens, [.splash])
    }

    func test_app_whenCompletedSplash_shouldShowHomeScreen() {
        // Given
        let sut = createAppStore(initial: AppState())

        // When
        sut.dispatch(AppAction.showScreen(.home))

        // Then
        XCTAssertEqual(sut.state.screens, [.home(.init())])
    }

    func test_app_whenStartedGame_shouldShowGameScreen() throws {
        // Given
        let sut = createAppStore(initial: AppState(screens: [.home(.init())]))

        // When
        sut.dispatch(AppAction.showScreen(.game))

        // Then
        guard case .game = sut.state.screens.last else {
            XCTFail("Invalid last screen")
            return
        }
    }

    func test_app_whenFinishedGame_shouldBackToHomeScreen() throws {
        // Given
        let sut = createAppStore(
            initial: AppState(
                screens: [
                    .home(.init()),
                    .game(.init(players: []))
                ]
            )
        )

        // When
        sut.dispatch(AppAction.dismissScreen(.game))

        // Then
        guard case .home = sut.state.screens.last else {
            XCTFail("Invalid last screen")
            return
        }
    }
}
