//
//  AppFlowTests.swift
//  WildWestOnlineTests
//
//  Created by Hugues Telolahy on 02/04/2023.
//
@testable import UI
import Redux
import XCTest
import Game

final class AppFlowTests: XCTestCase {

    private func createAppStore(initial: AppState) -> Store<AppState, AppAction> {
        Store(initial: initial,
              reducer: AppReducer().reduce,
              middlewares: [])
    }
    
    func test_App_WhenInitialized_ShouldShowSplashScreen() {
        // Given
        // When
        let sut = createAppStore(initial: AppState(screens: [.splash]))
        
        // Then
        XCTAssertEqual(sut.state.screens, [.splash])
    }
    
    func test_App_WhenCompletedSplash_ShowHomeScreen() {
        // Given
        let sut = createAppStore(initial: AppState(screens: [.splash]))
        
        // When
        sut.dispatch(.showScreen(.home))
        
        // Then
        XCTAssertEqual(sut.state.screens, [.home(.init())])
    }
    
    func test_App_WhenStartedGame_ShouldShowGameScreen() throws {
        // Given
        let sut = createAppStore(initial: AppState(screens: [.home(.init())]))
        
        // When
        sut.dispatch(.showScreen(.game))
        
        // Then
        guard case .game = sut.state.screens.last else {
            XCTFail("Invalid last screen")
            return
        }
    }
    
    func test_App_WhenFinishedGame_ShouldBackToHomeScreen() throws {
        // Given
        let sut = createAppStore(initial: AppState(screens: [.home(.init()),
                                                             .game(.init(players: []))]))
        
        // When
        sut.dispatch(.dismissScreen(.game))
        
        // Then
        guard case .home = sut.state.screens.last else {
            XCTFail("Invalid last screen")
            return
        }
    }
}
