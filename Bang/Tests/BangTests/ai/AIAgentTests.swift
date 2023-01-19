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
    
    func test_ChooseAction_IfGameWaitingChoice() {
        // Given
        let move1 = Choose(actor: "p1", label: "c1")
        let move2 = Choose(actor: "p1", label: "c2")
        let ctx = GameImpl(event: .success(ChooseOne([move1, move2])))
        mockEngine = MockEngine(ctx, queue: [ChooseOne([move1, move2])])
        
        let expectation = expectation(description: "AI input one of requested move")
        mockEngine.inputCallback = { move in
            if let choose = move as? Choose,
               choose == move1 || choose == move2 {
                expectation.fulfill()
            }
        }
        
        // When
        sut.playAny(mockEngine)
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_ChooseAction_IfGameEmittedActiveMoves() {
        // Given
        let move1 = DummyMove()
        let move2 = DummyMove()
        let ctx = GameImpl(event: .success(Activate([move1, move2])))
        mockEngine = MockEngine(ctx)
        
        let expectation = expectation(description: "AI input one of requested move")
        mockEngine.inputCallback = { move in
            if move is DummyMove {
                expectation.fulfill()
            }
        }
        
        // When
        sut.playAny(mockEngine)
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
}
