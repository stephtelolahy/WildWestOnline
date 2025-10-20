//
//  HomeViewTest.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

@testable import HomeUI
import Testing
import AppCore
import GameCore
import SettingsCore

struct HomeViewTest {
    @Test func HomeStateProjection() async throws {
        // Given
        let appState = AppFeature.State(
            inventory: Inventory.makeBuilder().build(),
            navigation: .init(),
            settings: SettingsFeature.State.makeBuilder().build()
        )

        // When
        let viewState = HomeView.ViewState(appState: appState)

        // Then
        #expect(viewState != nil)
    }
}
