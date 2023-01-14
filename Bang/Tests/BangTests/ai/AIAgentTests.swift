//
//  AIAgentTests.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//
// swiftlint:disable implicitly_unwrapped_optional

import XCTest
import Bang
import Combine

final class AIAgentTests: XCTestCase {
    
    private let sut: AIAgent = AIAgentImpl(strategy: AIStrategyRandom())
    private var mockEngine: MockEngine!
    
    func test_ChooseAction_IfGameWaitingDecision() {
        // Given
        let move1 = Dummy()
        let move2 = Dummy()
        let ctx = GameImpl(options: [move1, move2])
        mockEngine = MockEngine(ctx)
        
        let expectation = expectation(description: "AI should input one of requested move")
        mockEngine.inputCallback = { move in
            if move is Dummy {
                expectation.fulfill()
            }
        }
        
        // When
        sut.playAny(mockEngine)
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
}
