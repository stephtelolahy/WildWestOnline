//
//  SettingsViewModelTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
import Redux
import Settings
import SettingsCore
import XCTest

final class SettingsViewModelTests: XCTestCase {
    private let sut = SettingsView.Connector()

    func test_SettingsStateProjection() throws {
        // Given
        let appState = AppState(
            screens: [.home],
            settings: SettingsState.makeBuilder().withPlayersCount(3).build()
        )
        // When
        let settingsState = try XCTUnwrap(sut.deriveState(appState))
        // Then
        XCTAssertEqual(settingsState.playersCount, 3)
    }

    func test_SettingsEmbedAction() throws {
        // Given
        let appState = AppState(
            screens: [.home],
            settings: SettingsState.makeBuilder().build()
        )
        // When
        // Then
        XCTAssertEqual(sut.embedAction(.didToggleSimulation, state: appState), .settings(.toggleSimulation))
    }
}