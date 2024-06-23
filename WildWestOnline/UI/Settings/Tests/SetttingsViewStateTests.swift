//
//  SetttingsViewStateTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
import Redux
import Settings
import SettingsCore
import XCTest

final class SetttingsViewStateTests: XCTestCase {
    func test_SettingsStateProjection() throws {
        // Given
        let appState = AppState(
            screens: [.home],
            settings: SettingsState.makeBuilder().withPlayersCount(3).build()
        )

        // When
        let settingsState = try XCTUnwrap(SettingsView.deriveState(appState))

        // Then
        XCTAssertEqual(settingsState.playersCount, 3)
    }
}
