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
        let state = AppState(screens: [.splash], settings: .sample)

        // When
        let action = AppAction.navigate(.home)
        let result = AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home])
    }

    func test_app_whenStartedGame_shouldShowGameScreen_AndCreateGame() throws {
        // Given
        let state = AppState(screens: [.home], settings: .sample)

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
            settings: .sample,
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
            settings: .sample
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
            settings: .sample
        )

        // When
        let action = AppAction.close
        let result = AppState.reducer(state, action)

        // Then
        XCTAssertEqual(result.screens, [.home])
    }
}

private extension SettingsState {
    static let sample: Self = .init(
        inventory: .sample,
        playersCount: 5,
        waitDelayMilliseconds: 0
    )
}

private extension Inventory {
    static let sample: Self = .init(
        figures: (1...16).map { "c\($0)" },
        cardSets: [:],
        cardRef: Dictionary(uniqueKeysWithValues: (1...100).map { "c\($0)" }.map { ($0, Card.sample) })
    )
}

private extension Card {
    static let sample: Self = .init("", attributes: [.maxHealth: 4])
}
