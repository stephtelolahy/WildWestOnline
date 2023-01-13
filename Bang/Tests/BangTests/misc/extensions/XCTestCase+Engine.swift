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
    case wait([Effect])
    case input(Int)
}

/// Engine async testing pattern
extension XCTestCase {
    
    // swiftlint:disable:next function_body_length cyclomatic_complexity
    func createExpectation(
        engine sut: Engine,
        expected: [EngineEvent],
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let expectation = expectation(description: "Event sequence and decisions are correct")
        
        var expected = expected
        
        // swiftlint:disable:next closure_body_length
        sut.state.sink { [self] ctx in
            // verify event matches
            if let event = ctx.event {
                guard !expected.isEmpty else {
                    XCTFail("Received an event but expected is empty", file: file, line: line)
                    cancellables.removeAll()
                    return
                }
                
                switch event {
                case let .success(effect):
                    guard case let .success(expectedEffect) = expected.remove(at: 0) else {
                        XCTFail("Expected is not an effect")
                        cancellables.removeAll()
                        return
                    }
                    
                    guard let expectedEquatable = expectedEffect as? (any Equatable) else {
                        XCTFail("Expected is not equatable\(expectedEffect)")
                        cancellables.removeAll()
                        return
                    }
                    
                    assertEqual(effect, expectedEquatable, file: file, line: line)
                    
                case let .failure(error):
                    guard case let .error(expectedError) = expected.remove(at: 0) else {
                        XCTFail("Expected is not an error")
                        cancellables.removeAll()
                        return
                    }
                    
                    XCTAssertEqual(error, expectedError, file: file, line: line)
                }
            }
            
            // verify decision matches
            if !ctx.decisions.isEmpty {
                guard !expected.isEmpty else {
                    XCTFail("Received an decision but expected is empty", file: file, line: line)
                    cancellables.removeAll()
                    return
                }
                
                guard case let .wait(expectedOptions) = expected.remove(at: 0) else {
                    XCTFail("Expected is not a decision")
                    cancellables.removeAll()
                    return
                }
                
                guard ctx.decisions.count == expectedOptions.count else {
                    XCTFail("Expected decisions count does not match", file: file, line: line)
                    cancellables.removeAll()
                    return
                }
                
                for optionIndex in expectedOptions.indices {
                    guard let expectedOption = expectedOptions[optionIndex] as? (any Equatable) else {
                        XCTFail("Expected option is not equatable", file: file, line: line)
                        cancellables.removeAll()
                        return
                    }
                    
                    assertEqual(ctx.decisions[optionIndex], expectedOption, file: file, line: line)
                }
                
                // perform choice
                guard !expected.isEmpty else {
                    XCTFail("Should make a decision but expected is empty", file: file, line: line)
                    cancellables.removeAll()
                    return
                }
                
                guard case let .input(choiceIndex) = expected.remove(at: 0) else {
                    XCTFail("Expected should be a choice", file: file, line: line)
                    cancellables.removeAll()
                    return
                }
                
                sut.input(ctx.decisions[choiceIndex])
                return
            }
            
            // verify expected empty
            if expected.isEmpty {
                guard ctx.decisions.isEmpty else {
                    XCTFail("Expected is empty but decision remains \(ctx.decisions.count)", file: file, line: line)
                    cancellables.removeAll()
                    return
                }
                
                guard ctx.queue.isEmpty else {
                    XCTFail("Expected is empty but queue remains \(ctx.queue.count)", file: file, line: line)
                    cancellables.removeAll()
                    return
                }
                
                expectation.fulfill()
            }
        }
        .store(in: &cancellables)
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
