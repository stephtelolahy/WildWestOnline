//
//  SetttingsTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
import Redux
import Settings
import SettingsCore
import XCTest

final class SetttingsTests: XCTestCase {
    func test_SettingsStateProjection() throws {
        // Given
        let appState = AppState(
            screens: [.home],
            settings: SettingsState.makeBuilder().withPlayersCount(3).build()
        )
        let sut = Connectors.SettingsViewConnector()

        // When
        let settingsState = try XCTUnwrap(sut.deriveState(state: appState))

        // Then
        XCTAssertEqual(settingsState.playersCount, 3)
    }

    func test_SettingsEmbedAction() throws {
        // Given
        let sut = Connectors.SettingsViewConnector()

        // When
        // Then
        XCTAssertEqual(sut.embedAction(action: .toggleSimulation), .settings(.toggleSimulation))
    }
}
