//
//  NavigationCoreTests.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 24/07/2024.
//
import NavigationCore
import Testing

struct NavigationCoreTests {
    @Test func app_whenCompletedSplash_shouldSetHomeScreen() async throws {
        // Given
        let state = NavigationState()

        // When
        let action = NavigationStackAction<MainDestination>.push(.home)
        let result = try NavigationState.reducer(state, action)

        // Then
        #expect(result.main.path == [.home])
    }

    @Test func showingSettings_shouldDisplaySettings() async throws {
        // Given
        let state = NavigationState(root: .init(path: [.home]))

        // When
        let action = NavigationStackAction<MainDestination>.present(.settings)
        let result = try NavigationState.reducer(state, action)

        // Then
        #expect(result.main.sheet == .settings)
    }

    @Test func closingSettings_shouldRemoveSettings() async throws {
        // Given
        let state = NavigationState(root: .init(path: [.home], sheet: .settings))

        // When
        let action = NavigationStackAction<MainDestination>.dismiss
        let result = try NavigationState.reducer(state, action)

        // Then
        #expect(result.main.sheet == nil)
    }
}
