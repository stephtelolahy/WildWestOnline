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
    func test_HomeStateProjection() {
        // Given
        let appState = AppState(
            screens: [.home],
            settings: SettingsState.makeBuilder().build()
        )
        let sut = Connectors.HomeViewConnector()

        // When
        // Then
        XCTAssertEqual(sut.deriveState(state: appState), .init())
    }

    func test_embedActionOpenSettings() {
        let sut = Connectors.HomeViewConnector()
        XCTAssertEqual(sut.embedAction(action: .openSettings), .navigate(.settings))
    }

    func test_embedActionstartGame() {
        let sut = Connectors.HomeViewConnector()
        XCTAssertEqual(sut.embedAction(action: .startGame), .navigate(.game))
    }
}
