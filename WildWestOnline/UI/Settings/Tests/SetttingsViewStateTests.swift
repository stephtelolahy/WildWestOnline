//
//  SetttingsViewStateTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
import GameCore
import Redux
import SettingsCore
import SettingsUI
import XCTest

final class SetttingsViewStateTests: XCTestCase {
    private let sut = SettingsViewConnector()

    func test_SettingsStateProjection() throws {
        // Given
        let appState = AppState(
            navigation: .init(),
            settings: SettingsState.makeBuilder().withPlayersCount(3).build(),
            inventory: Inventory.makeBuilder().build()
        )

        // When
        let settingsState = try XCTUnwrap(sut.deriveState(appState))

        // Then
        XCTAssertEqual(settingsState.playersCount, 3)
    }
}
