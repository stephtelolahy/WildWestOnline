//
//  SplashTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
import Redux
import SettingsCore
import Splash
import XCTest

final class SplashTests: XCTestCase {
    func test_splashStateProjection() {
        // Given
        let appState = AppState(
            screens: [.splash],
            settings: SettingsState.makeBuilder().build()
        )
        let sut = Connectors.SplashViewConnector()

        // When
        // Then
        XCTAssertNotNil(sut.connect(state: appState))
    }
}