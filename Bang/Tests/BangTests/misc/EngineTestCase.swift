//
//  EngineTestCase.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//
// swiftlint:disable implicitly_unwrapped_optional
// swiftlint:disable test_case_accessibility

import XCTest
import Bang
import Combine

enum GameEvent {
    case success(Effect)
    case error(GameError)
    case wait([Effect], input: Int)
}

/// Testing card features using engine
class EngineTestCase: XCTestCase {
    
    var sut: Engine!
    
    let inventory: Inventory = InventoryImpl()
    
    private var events: [Result<Effect, GameError>] = []
    
    private var state: Game { sut.state.value }
    
    private var cancellables = Set<AnyCancellable>()
    
    /// Initialize Engine with given Game state
    func setupGame(_ ctx: Game) {
        sut = EngineImpl(ctx: ctx)
        sut.state.sink { [weak self] in
            self?.events.appendNotNil($0.event)
        }
        .store(in: &cancellables)
    }
    
    /// Assert events contains given events
    func assertSequence(_ expected: [GameEvent], file: StaticString = #filePath, line: UInt = #line) throws {
        for index in expected.indices {
            switch expected[index] {
            case let .success(expectedEffect):
                guard !events.isEmpty else {
                    throw IllegalStateError(message: "Expected event is success at index \(index) but is empty")
                }
                
                guard let equatableEffect = expectedEffect as? (any Equatable) else {
                    throw IllegalStateError(message: "Expected an equatable effect \(expectedEffect)")
                }
                
                assertIsSuccess(events.removeFirst(), equalTo: equatableEffect, file: file, line: line)
                
            case let .error(expectedError):
                guard !events.isEmpty else {
                    throw IllegalStateError(message: "Expected event is error at index \(index) but is empty")
                }
                
                assertIsFailure(events.removeFirst(), equalTo: expectedError, file: file, line: line)
                
            case let .wait(expectedOptions, input: choiceIndex):
                guard state.decisions.count == expectedOptions.count else {
                    throw IllegalStateError(message: "Expected decision has \(expectedOptions.count) options but got \(state.decisions.count)")
                }
                
                for optionIndex in expectedOptions.indices {
                    guard let expectedOption = expectedOptions[optionIndex] as? (any Equatable) else {
                        throw IllegalStateError(message: "Effect an equatable effect \(expectedOptions[index])")
                    }
                    
                    assertEqual(state.decisions[optionIndex], expectedOption, file: file, line: line)
                }
                
                sut.input(state.decisions[choiceIndex])
            }
        }
        
        XCTAssertTrue(events.isEmpty, "Expected all events asserted but remains \(events.count)", file: file, line: line)
        XCTAssertTrue(state.decisions.isEmpty, "Expected resolution completed but remains a decision", file: file, line: line)
        XCTAssertTrue(state.queue.isEmpty, "Expected game idle but remains queue \(state.queue.count)", file: file, line: line)
    }
}

private struct IllegalStateError: Error {
    let message: String
}
