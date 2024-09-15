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
        let state = NavigationState()

        // When
        let action = NavigationStackAction<RootDestination>.push(.home)
        let result = try NavigationState.reducer(state, action)

        // Then
        XCTAssertEqual(result.root.path, [.home])
    }

    func test_showingSettings_shouldDisplaySettings() throws {
        // Given
        let state = NavigationState(root: .init(path: [.home]))

        // When
        let action = NavigationStackAction<RootDestination>.present(.settings)
        let result = try NavigationState.reducer(state, action)

        // Then
        XCTAssertEqual(result.root.sheet, .settings)
    }

    func test_closingSettings_shouldRemoveSettings() throws {
        // Given
        let state = NavigationState(root: .init(path: [.home], sheet: .settings))

        // When
        let action = NavigationStackAction<RootDestination>.dismiss
        let result = try NavigationState.reducer(state, action)

        // Then
        XCTAssertNil(result.root.sheet)
    }
}
