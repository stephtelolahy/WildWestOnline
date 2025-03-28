//
//  SplashViewTest.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

@testable import SplashUI
import Testing
import AppCore
import GameCore
import SettingsCore

struct SplashViewTest {
    @Test func splashStateProjection() async throws {
        // Given
        let appState = AppFeature.State(
            navigation: .init(),
            settings: SettingsFeature.State.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build()
        )

        // When
        let viewState = SplashView.State(appState: appState)

        // Then
        #expect(viewState != nil)
    }
}
