//
//  HomeViewStateTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
import GameCore
import HomeUI
import Redux
import SettingsCore
import XCTest

final class HomeViewStateTests: XCTestCase {
    func test_HomeStateProjection() throws {
        // Given
        let appState = AppState(
            screens: [.home],
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build()
        )

        // When
        // Then
        XCTAssertNotNil(HomeView.deriveState(appState))
    }
}
