//
//  SplashViewStateTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
import GameCore
import Redux
import SettingsCore
@testable import SplashUI
import XCTest

final class SplashViewStateTests: XCTestCase {

    private let sut = SplashViewConnector()

    func test_splashStateProjection() throws {
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
