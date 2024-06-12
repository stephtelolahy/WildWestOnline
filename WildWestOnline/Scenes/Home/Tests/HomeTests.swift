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
    private let sut = Connectors.HomeViewConnector()

    func test_HomeStateProjection() {
        // Given
        let appState = AppState(
            screens: [.home],
            settings: SettingsState.makeBuilder().build()
        )
        // When
        // Then
        XCTAssertEqual(sut.deriveState(state: appState), .init())
    }

    func test_embedActionOpenSettings() {
        XCTAssertEqual(sut.embedAction(action: .didTapSettingsButton), .navigate(.settings))
    }

    func test_embedActionStartGame() {
        XCTAssertEqual(sut.embedAction(action: .didTapPlayButton), .navigate(.game))
    }
}
