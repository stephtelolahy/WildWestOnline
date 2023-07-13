//
//  Store+Action.swift
//  
//
//  Created by Hugues Telolahy on 08/04/2023.
//

import Game
import XCTest
import Redux

extension XCTestCase {
    
    func awaitAction(
        _ action: GameAction,
        choices: [String] = [],
        state: GameState,
        timeout: TimeInterval = 0.5,
        file: StaticString = #file,
        line: UInt = #line
    ) -> [GameAction] {
        let store = createGameStore(initial: state)
        var choices = choices
        var events: [GameAction] = []
        let expectation = XCTestExpectation(description: "Awaiting game idle")
        expectation.isInverted = true
        let cancellable = store.$state.dropFirst(1).sink { state in
            if let event = state.event,
               event.isRenderable {
                events.append(event)
            }

            if let chooseOne = state.chooseOne {
                guard !choices.isEmpty else {
                    XCTFail("Expected a choice between \(chooseOne.options.keys)", file: file, line: line)
                    return
                }
                
                let choice = choices.removeFirst()
                guard let chooseOne = chooseOne.options[choice] else {
                    XCTFail("Expect chooseOne with option \(choice)", file: file, line: line)
                    return
                }
                
                DispatchQueue.main.async {
                    store.dispatch(chooseOne)
                }
                return
            }
            
            if state.queue.isEmpty {
                expectation.fulfill()
            }
        }
        
        store.dispatch(action)
        
        wait(for: [expectation], timeout: timeout)
        cancellable.cancel()
        
        XCTAssertTrue(store.state.queue.isEmpty, "Game must be idle", file: file, line: line)
        XCTAssertTrue(store.state.chooseOne == nil, "Game must be idle", file: file, line: line)
        
        return events
    }
}
