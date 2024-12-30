//
//  SetttingsViewTest.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import AppCore
import GameCore
import Redux
import SettingsCore
@testable import SettingsUI
import Testing

struct SetttingsViewTest {
    @Test func SettingsStateProjection() async throws {
        // Given
        let appState = AppState(
            navigation: .init(),
            settings: SettingsState.makeBuilder().withPlayersCount(3).build(),
            inventory: Inventory.makeBuilder().build()
        )

        // When
        let settingsState = try #require(await SettingsHomeView.presenter(appState))

        // Then
        #expect(settingsState.playersCount == 3)
    }
}
