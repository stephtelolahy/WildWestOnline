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
import Testing
import XCTest

struct AppCoreTests {
    @Test func app_whenStartedGame_shouldShowGameScreen_AndCreateGame() async throws {
        // Given
        let state = AppState(
            navigation: .init(root: .init(path: [.home])),
            settings: SettingsState.makeBuilder().withPlayersCount(5).build(),
            inventory: Inventory.makeBuilder().withSample().build()
        )
        let sut = Store<AppState>(
            initial: state,
            reducer: AppReducer().reduce,
            middlewares: [Middlewares.gameSetup()]
        )

        let expectation = XCTestExpectation(description: "Awaiting store idle")
        expectation.isInverted = true

        // When
        let action = GameSetupAction.startGame
        sut.dispatch(action)

        // Then
        let waiter = XCTWaiter()
        await waiter.fulfillment(of: [expectation], timeout: 0.1)
        #expect(sut.state.navigation.main.path == [.home, .game])
        #expect(sut.state.game != nil)
    }

    @Test func app_whenFinishedGame_shouldBackToHomeScreen_AndDeleteGame() async throws {
        // Given
        let state = AppState(
            navigation: .init(root: .init(path: [.home, .game])),
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build(),
            game: GameState.makeBuilder().build()
        )
        let sut = Store<AppState>(
            initial: state,
            reducer: AppReducer().reduce,
            middlewares: [Middlewares.gameSetup()]
        )

        let expectation = XCTestExpectation(description: "Awaiting store idle")
        expectation.isInverted = true

        // When
        let action = GameSetupAction.quitGame
        sut.dispatch(action)

        // Then
        let waiter = XCTWaiter()
        await waiter.fulfillment(of: [expectation], timeout: 0.1)
        #expect(sut.state.navigation.main.path == [.home])
        #expect(sut.state.game == nil)
    }
}
