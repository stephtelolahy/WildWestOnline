//
//  HomeTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
import Home
import XCTest

final class HomeTests: XCTestCase {

    func test_HomeStateProjection() {
        // Given
        let appState = AppState(screens: [.home], settings: .init(playersCount: 3))

        // When
        // Then
        XCTAssertNotNil(HomeView.State.from(globalState: appState))
    }
}
