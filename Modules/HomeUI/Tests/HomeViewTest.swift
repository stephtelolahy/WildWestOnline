//
//  HomeViewTest.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 24/02/2024.
//

import HomeUI
import Testing
import AppFeature
import GameFeature
import SettingsFeature

struct HomeViewTest {
    @Test func HomeStateProjection() async throws {
        // Given
        let appState = AppFeature.State(
            cardLibrary: .init(),
            navigation: .init(),
            settings: SettingsFeature.State.makeBuilder().build()
        )

        // When
        let viewState = HomeView.ViewState(appState: appState)

        // Then
        #expect(viewState != nil)
    }
}
