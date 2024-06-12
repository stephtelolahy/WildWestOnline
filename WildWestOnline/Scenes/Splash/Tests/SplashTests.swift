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
    private let sut = Connectors.SplashViewConnector()

    func test_deriveState() {
        // Given
        let appState = AppState(
            screens: [.splash],
            settings: SettingsState.makeBuilder().build()
        )
        // When
        // Then
        XCTAssertEqual(sut.deriveState(appState), .init())
    }

    func test_embedActionFinish() {
        // Given
        // When
        // Then
        XCTAssertEqual(sut.embedAction(.didAppear), .navigate(.home))
    }
}
