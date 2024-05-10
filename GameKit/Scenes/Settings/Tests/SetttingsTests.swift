//
//  SetttingsTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
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

        // When
        let settingsState = try XCTUnwrap(SettingsView.State.from(globalState: appState))

        // Then
        XCTAssertEqual(settingsState.playersCount, 3)
    }
}
