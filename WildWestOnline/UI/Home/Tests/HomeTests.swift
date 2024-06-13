//
//  HomeTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
@testable import Home
import Redux
import SettingsCore
import XCTest

final class HomeTests: XCTestCase {
    private let sut = HomeView.Connector.self

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
        XCTAssertEqual(sut.embedAction(.didTapSettingsButton), .navigate(.settings))
    }

    func test_embedActionStartGame() {
        XCTAssertEqual(sut.embedAction(.didTapPlayButton), .createGame)
    }
}
