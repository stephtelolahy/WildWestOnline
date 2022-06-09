//
//  RandomAITests.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 03/06/2022.
//

import XCTest
import CardGameCore

class RandomAITests: XCTestCase {

    func test_ChooseAction_IfGameWaitingDecision() {
        // Given
        let move1 = DummyMove(id: "m1")
        let move2 = DummyMove(id: "m2")
        let ctx1 = Sequence(actor: "p1")
        let decision = Decision(options: [move1, move2], cardRef: "c1")
        let state = State(sequences: ["p1": ctx1], decisions: ["p1": decision])
        let mockGame = MockGame(state)
        let sut = RandomAI()
        
        let expectation = XCTestExpectation(description: "AI should input a valid move")
        mockGame.inputCallback = { command in
            XCTAssertTrue(command as? DummyMove == move1 || command as? DummyMove == move2 )
            expectation.fulfill()
        }
        
        // When
        sut.observe(game: mockGame)
        
        // Assert
        wait(for: [expectation], timeout: 0.1)
    }

}
