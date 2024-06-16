//
//  HomeViewModelTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
@testable import Home
import Redux
import SettingsCore
import XCTest

final class HomeViewModelTests: XCTestCase {
    func test_HomeStateProjection() {
        // Given
        let appState = AppState(
            screens: [.home],
            settings: SettingsState.makeBuilder().build()
        )
        // When
        // Then
        XCTAssertEqual(HomeView.deriveState(appState), .init())
    }

    func test_embedActionOpenSettings() {
        XCTAssertEqual(HomeView.embedAction(.didTapSettingsButton), .navigate(.settings))
    }

    func test_embedActionStartGame() {
        XCTAssertEqual(HomeView.embedAction(.didTapPlayButton), .createGame)
    }
}
