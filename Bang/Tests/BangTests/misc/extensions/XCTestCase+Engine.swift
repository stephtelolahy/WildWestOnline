//
//  XCTestCase+Engine.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
// swiftlint:disable closure_body_length

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
        let expectation = expectation(description: "Event sequence and options are correct")
        
        var expected = expected
        
        // Observe game state ignoring initial state
        sut.state
            .dropFirst(1)
            .sink { [self] ctx in
                // verify event matches
                if let event = ctx.event {
                    guard !expected.isEmpty else {
                        XCTFail("Expected is empty but received \(event)", file: file, line: line)
                        cancellables.removeAll()
                        return
                    }
                    
                    let expectedEvent = expected.remove(at: 0)
                    
                    switch event {
                    case let .success(effect):
                        guard case let .success(expectedEffect) = expectedEvent,
                              let expectedEquatable = expectedEffect as? (any Equatable) else {
                            XCTFail("Expected \(expectedEvent) is different from received \(effect)", file: file, line: line)
                            cancellables.removeAll()
                            return
                        }
                        
                        assertEqual(effect, expectedEquatable, file: file, line: line)
                        
                    case let .failure(error):
                        guard case let .error(expectedError) = expectedEvent else {
                            XCTFail("Expected \(expectedEvent) is different from received \(error)", file: file, line: line)
                            cancellables.removeAll()
                            return
                        }
                        
                        XCTAssertEqual(error, expectedError, file: file, line: line)
                    }
                }
                
                // verify options matches
                if !ctx.options.isEmpty {
                    guard !expected.isEmpty else {
                        XCTFail("Expected is empty but received options \(ctx.options)", file: file, line: line)
                        cancellables.removeAll()
                        return
                    }
                    
                    var expectedEvent = expected.remove(at: 0)
                    
                    guard case let .wait(expectedOptions) = expectedEvent,
                          ctx.options.count == expectedOptions.count else {
                        XCTFail("Expected \(expectedEvent) is different from received \(ctx.options)", file: file, line: line)
                        cancellables.removeAll()
                        return
                    }
                    
                    for optionIndex in expectedOptions.indices {
                        guard let expectedOption = expectedOptions[optionIndex] as? (any Equatable) else {
                            XCTFail("Expected \(expectedEvent) is different from received \(ctx.options)", file: file, line: line)
                            cancellables.removeAll()
                            return
                        }
                        
                        assertEqual(ctx.options[optionIndex], expectedOption, file: file, line: line)
                    }
                    
                    // perform choice
                    guard !expected.isEmpty else {
                        XCTFail("Expected is empty but should make a choice \(ctx.options)", file: file, line: line)
                        cancellables.removeAll()
                        return
                    }
                    
                    expectedEvent = expected.remove(at: 0)
                    
                    guard case let .input(choiceIndex) = expectedEvent else {
                        XCTFail("Expected \(expectedEvent) shoudl be a choice", file: file, line: line)
                        cancellables.removeAll()
                        return
                    }
                    
                    sut.input(ctx.options[choiceIndex])
                    return
                }
                
                // verify expected empty
                if expected.isEmpty {
                    guard ctx.options.isEmpty else {
                        XCTFail("Expected is empty but options remains \(ctx.options.count)", file: file, line: line)
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
