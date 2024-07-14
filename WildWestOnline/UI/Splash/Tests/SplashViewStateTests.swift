//
//  SplashViewStateTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
import Redux
import SettingsCore
import Splash
import XCTest

final class SplashViewStateTests: XCTestCase {
    func test_splashStateProjection() throws {
        // Given
        let appState = AppState(
            screens: [.splash],
            settings: SettingsState.makeBuilder().build()
        )

        // When
        // Then
        XCTAssertNotNil(SplashView.deriveState(appState))
    }
}
