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
@testable import SettingsUI
import XCTest

final class SetttingsViewStateTests: XCTestCase {
    func test_SettingsStateProjection() throws {
        // Given
        let appState = AppState(
            navigation: .init(),
            settings: SettingsState.makeBuilder().withPlayersCount(3).build(),
            inventory: Inventory.makeBuilder().build()
        )

        // When
        let settingsState = try XCTUnwrap(SettingsHomeView.presenter(appState))

        // Then
        XCTAssertEqual(settingsState.playersCount, 3)
    }
}
