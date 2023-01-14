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
        let ctx = GameImpl(isOver: true, queue: [Dummy()])
        let sut = EngineImpl(ctx)
        
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
    
}
