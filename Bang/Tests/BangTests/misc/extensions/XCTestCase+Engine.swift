//
//  XCTestCase+Engine.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//

import XCTest
import Combine
import Bang

/// Engine event
enum EngineEvent {
    case success(Effect)
    case error(GameError)
    case input(Int)
}

/// Engine async testing pattern
extension XCTestCase {
    
    func createExpectation(
        engine sut: Engine,
        expected: [EngineEvent],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectation = expectation(description: "Event sequence is correct")
        var expected = expected
        
        // Observe game state ignoring initial state
        sut.state
            .dropFirst(1)
            .sink { [self] ctx in
                if let event = ctx.event {
                    
                    // verify event matches
                    switch event {
                    case let .success(effect):
                        assertEqualEffect(effect, expected: expected.removeSafe(at: 0), file: file, line: line)
                        
                        // if waiting, then make choice
                        if let chooseOne = effect as? ChooseOne {
                            assertPerformChoice(chooseOne.getOptions(), expected: expected.removeSafe(at: 0), sut: sut, file: file, line: line)
                            return
                        }
                        
                    case let .failure(error):
                        assertEqualError(error, expected: expected.removeSafe(at: 0), file: file, line: line)
                    }
                }
                
                // verify completed
                if expected.isEmpty && sut.queue.isEmpty {
                    expectation.fulfill()
                }
            }
            .store(in: &cancellables)
    }
}

private extension XCTestCase {
    
    func assertEqualEffect(_ effect: Effect, expected: EngineEvent?, file: StaticString = #file, line: UInt = #line) {
        guard case let .success(expectedEffect) = expected,
              let expectedEquatable = expectedEffect as? (any Equatable) else {
            XCTFail("Observed \(effect) is different from expected \(String(describing: expected)) ", file: file, line: line)
            cancellables.removeAll()
            return
        }
        
        assertEqual(effect, expectedEquatable, file: file, line: line)
    }
    
    func assertEqualError(_ error: GameError, expected: EngineEvent?, file: StaticString = #file, line: UInt = #line) {
        guard case let .error(expectedError) = expected else {
            XCTFail("Observed \(error) is different from expected \(String(describing: expected))", file: file, line: line)
            cancellables.removeAll()
            return
        }
        
        XCTAssertEqual(error, expectedError, file: file, line: line)
    }
    
    func assertPerformChoice(_ options: [Effect], expected: EngineEvent?, sut: Engine, file: StaticString = #file, line: UInt = #line) {
        guard case let .input(choiceIndex) = expected else {
            XCTFail("Expected \(String(describing: expected)) should be a choice", file: file, line: line)
            cancellables.removeAll()
            return
        }
        
        sut.input(options[choiceIndex])
    }
}

private extension XCTestCase {
    
    private enum Holder {
        static var cancellablesDict: [String: Set<AnyCancellable>] = [:]
    }
    
    private var cancellables: Set<AnyCancellable> {
        get {
            Holder.cancellablesDict[debugDescription] ?? Set<AnyCancellable>()
        }
        set(newValue) {
            Holder.cancellablesDict[debugDescription] = newValue
        }
    }
}
