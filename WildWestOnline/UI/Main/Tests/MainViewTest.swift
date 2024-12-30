//
//  MainViewTest.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 30/12/2024.
//

import Testing
import AppCore
@testable import MainUI
import SettingsCore
import GameCore

struct MainViewTest {
    @Test func MainStateProjection() async throws {
        // Given
        let appState = AppState(
            navigation: .init(),
            settings: SettingsState.makeBuilder().build(),
            inventory: Inventory.makeBuilder().build()
        )

        // When
        // Then
        await #expect(MainView.presenter(appState) != nil)
    }
}
