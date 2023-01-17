//
//  EngineTests.swift
//  
//
//  Created by Hugues Telolahy on 14/01/2023.
//

import XCTest
import Combine
import Bang

class EngineTests: XCTestCase {
    
    private var cancellables = Set<AnyCancellable>()
    
    func test_StopUpdates_IfGameIsOver() {
        // Given
        let ctx = GameImpl(isOver: true)
        let sut = EngineImpl(ctx, queue: [DummyEffect()])
        let expectation = expectation(description: "move is queued")
        expectation.isInverted = true
        sut.state.sink { ctx in
            if case let .success(event) = ctx.event,
               event is DummyEffect {
                expectation.fulfill()
            }
        }
        .store(in: &cancellables)
        
        // When
        sut.update()
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_SetTurnToSheriff_IfStartingGame() {
        // Given
        let ctx = GameImpl(playOrder: ["p1", "p2", "p3"])
        let sut = EngineImpl(ctx)
        
        // When
        sut.start()
        
        // Assert
        XCTAssertEqual(sut.queue.count, 1)
        assertEqual(sut.queue[0], SetTurn(player: PlayerId("p1")))
    }
    
    func test_QueueAnyInputMove_IfIdle() {
        // Given
        let ctx = GameImpl()
        let sut = EngineImpl(ctx)
        let move = DummyMove()
        let expectation = expectation(description: "move is queued")
        sut.state.sink { ctx in
            if case let .success(event) = ctx.event,
               event is DummyMove {
                expectation.fulfill()
            }
        }
        .store(in: &cancellables)
        
        // When
        sut.input(move)
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_QueueMove_IfWaitingAndValid() {
        // Given
        let ctx = GameImpl()
        let move = Choose(actor: "p1", label: "c1", children: [DummyEffect()])
        let sut = EngineImpl(ctx, queue: [ChooseOne([move])])
        let expectation = expectation(description: "move is queued")
        sut.state.sink { ctx in
            if case let .success(event) = ctx.event,
               event is Choose {
                expectation.fulfill()
            }
        }
        .store(in: &cancellables)
        
        // When
        sut.input(move)
        
        // Assert
        waitForExpectations(timeout: 0.1)
    }
    
    func test_DoNotQueueMove_IfWaitingAndInvalid() {
        // Given
        let ctx = GameImpl()
        let move1 = Choose(actor: "p1", label: "c1")
        let sut = EngineImpl(ctx, queue: [ChooseOne([move1])])
        let move = DummyMove()
        
        let expectation = expectation(description: "move is not queued")
        expectation.isInverted = true
        
        sut.state.sink { ctx in
            if case let .success(event) = ctx.event,
               event is DummyMove {
                expectation.fulfill()
            }
        }
        .store(in: &cancellables)
        
        // When
        sut.input(move)
        
        // Assert
        waitForExpectations(timeout: 0.1)
        XCTAssertEqual(sut.queue.count, 1)
        XCTAssertTrue(sut.queue[0] is ChooseOne)
    }
}
