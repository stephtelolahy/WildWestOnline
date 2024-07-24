//
//  NavigationCoreTests.swift
//
//
//  Created by Stephano Hugues TELOLAHY on 24/07/2024.
//
import NavigationCore
import XCTest

final class NavigationCoreTests: XCTestCase {
    func test_app_whenCompletedSplash_shouldSetHomeScreen() throws {
        // Given
        let state: ScreenState = [.splash]

        // When
        let action = NavigationAction.navigate(.home)
        let result = try ScreenState.reducer(state, action)

        // Then
        XCTAssertEqual(result, [.home])
    }

    func test_showingSettings_shouldDisplaySettings() throws {
        // Given
        let state: ScreenState = [.home]

        // When
        let action = NavigationAction.navigate(.settings)
        let result = try ScreenState.reducer(state, action)

        // Then
        XCTAssertEqual(result, [.home, .settings])
    }

    func test_closingSettings_shouldRemoveSettings() throws {
        // Given
        let state: ScreenState = [.home, .settings]

        // When
        let action = NavigationAction.close
        let result = try ScreenState.reducer(state, action)

        // Then
        XCTAssertEqual(result, [.home])
    }
}
