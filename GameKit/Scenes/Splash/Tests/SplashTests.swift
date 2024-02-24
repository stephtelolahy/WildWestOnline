//
//  SplashTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
import Splash
import XCTest

final class SplashTests: XCTestCase {

    func test_splashStateProjection() {
        // Given
        let appState = AppState(screens: [.splash], settings: .init(playersCount: 3))

        // When
        // Then
        XCTAssertNotNil(SplashState.from(globalState: appState))
    }
}
