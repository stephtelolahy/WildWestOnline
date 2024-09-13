//
//  HomeViewStateTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
import GameCore
@testable import HomeUI
import Redux
import SettingsCore
import XCTest

final class HomeViewStateTests: XCTestCase {
    private let sut = HomeViewConnector()

    func test_HomeStateProjection() throws {
        // Given
        let appState = AppState(
            navigation: .init(),
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build()
        )

        // When
        // Then
        XCTAssertNotNil(sut.deriveState(appState))
    }
}
