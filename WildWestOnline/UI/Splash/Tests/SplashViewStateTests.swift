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
import Testing

struct SplashViewStateTests {
    @Test func splashStateProjection() async throws {
        // Given
        let appState = AppState(
            navigation: .init(),
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build()
        )

        // When
        // Then
        await #expect(SplashView.presenter(appState) != nil)
    }
}
