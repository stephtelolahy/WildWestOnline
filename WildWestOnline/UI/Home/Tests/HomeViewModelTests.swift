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
    private let sut = HomeView.Connector()

    func test_HomeStateProjection() {
        // Given
        let appState = AppState(
            screens: [.home],
            settings: SettingsState.makeBuilder().build()
        )
        // When
        // Then
        XCTAssertEqual(sut.deriveState(appState), .init())
    }

    func test_embedActionOpenSettings() {
        let appState = AppState(
            screens: [.home],
            settings: SettingsState.makeBuilder().build()
        )
        XCTAssertEqual(sut.embedAction(.didTapSettingsButton, state: appState), .navigate(.settings))
    }

    func test_embedActionStartGame() {
        let appState = AppState(
            screens: [.home],
            settings: SettingsState.makeBuilder().build()
        )
        XCTAssertEqual(sut.embedAction(.didTapPlayButton, state: appState), .createGame)
    }
}
