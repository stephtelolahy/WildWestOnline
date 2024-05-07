//
//  SetttingsTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
import Settings
import XCTest

final class SetttingsTests: XCTestCase {
    func test_SettingsStateProjection() throws {
        // Given
        let appState = AppState(screens: [.home], settings: .init(playersCount: 3))

        // When
        let settingsState = try XCTUnwrap(SettingsView.State.from(globalState: appState))

        // Then
        XCTAssertEqual(settingsState.playersCount, 3)
    }
}
