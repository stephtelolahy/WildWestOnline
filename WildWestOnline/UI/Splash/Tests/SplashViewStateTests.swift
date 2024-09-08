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
import SplashUI
import XCTest

final class SplashViewStateTests: XCTestCase {
    func test_splashStateProjection() throws {
        // Given
        let appState = AppState(
            navigation: .init(path: [.splash]),
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build()
        )

        // When
        // Then
        XCTAssertNotNil(SplashView.deriveState(appState))
    }
}
