//
//  SplashTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
import Redux
import SettingsCore
@testable import Splash
import XCTest

final class SplashTests: XCTestCase {
    func test_deriveState() {
        // Given
        let appState = AppState(
            screens: [.splash],
            settings: SettingsState.makeBuilder().build()
        )
        let sut = Connectors.SplashViewConnector()

        // When
        // Then
        XCTAssertEqual(sut.deriveState(state: appState), SplashView.State())
    }

    func test_embedActionFinish() {
        // Given
        let sut = Connectors.SplashViewConnector()

        // When
        // Then
        XCTAssertEqual(sut.embedAction(action: .finish), AppAction.navigate(.home))
    }
}
