//
//  SplashViewModelTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
import Redux
import SettingsCore
@testable import Splash
import XCTest

final class SplashViewModelTests: XCTestCase {
    private let sut = SplashView.Connector()

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
        let appState = AppState(
            screens: [.splash],
            settings: SettingsState.makeBuilder().build()
        )
        // When
        // Then
        XCTAssertEqual(sut.embedAction(.didAppear, state: appState), .navigate(.home))
    }
}