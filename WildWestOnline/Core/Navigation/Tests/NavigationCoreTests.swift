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
        let state = NavigationState(path: [.splash])
        
        // When
        let action = NavigationAction.push(.home)
        let result = try NavigationState.reducer(state, action)
        
        // Then
        XCTAssertEqual(result.path, [.home])
    }
    
    func test_showingSettings_shouldDisplaySettings() throws {
        // Given
        let state = NavigationState(path: [.home])
        
        // When
        let action = NavigationAction.present(.settings)
        let result = try NavigationState.reducer(state, action)
        
        // Then
        XCTAssertEqual(result.sheet, .settings)
    }
    
    func test_closingSettings_shouldRemoveSettings() throws {
        // Given
        let state = NavigationState(path: [.home], sheet: .settings)
        
        // When
        let action = NavigationAction.dismiss
        let result = try NavigationState.reducer(state, action)
        
        // Then
        XCTAssertNil(result.sheet)
    }
}
