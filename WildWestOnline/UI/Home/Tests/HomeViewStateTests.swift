//
//  HomeViewStateTests.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
import GameCore
@testable import HomeUI
import Redux
import SettingsCore
import Testing

struct HomeViewStateTests {
    @Test func HomeStateProjection() throws {
        // Given
        let appState = AppState(
            navigation: .init(),
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build()
        )

        // When
        // Then
        #expect(HomeView.presenter(appState) != nil)
    }
}
