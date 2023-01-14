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
        let sut = EngineImpl(ctx, queue: [Dummy()])
        
        var events: [Result<Effect, GameError>] = []
        sut.state.sink {
            events.appendNotNil($0.event)
        }
        .store(in: &cancellables)
        
        // When
        sut.update()
        
        // Assert
        XCTAssertEqual(events.count, 0)
    }
    
    func test_SetTurnToSheriff_IfStartingGame() {
        // Given
        let ctx = GameImpl(playOrder: ["p1", "p2", "p3"])
        let sut = EngineImpl(ctx)
        
        // When
        sut.start()
        
        // Assert
        XCTAssertEqual(sut.queue.count, 1)
        XCTAssertEqual(sut.queue.first as? SetTurn, SetTurn(player: PlayerId("p1")))
    }
    
}
