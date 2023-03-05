//
//  EngineTests.swift
//
//
//  Created by Hugues Telolahy on 14/01/2023.
//

import XCTest
import Combine
import GameDSL
import Cuckoo
@testable import CardGame

class CardGameEngineTests: XCTestCase {

    private var mockRule: MockCardGameEngineRule!
    private var cancellables = Set<AnyCancellable>()

    // swiftlint:disable:next overridden_super_call
    override func setUp() {
        mockRule = MockCardGameEngineRule().withEnabledDefaultImplementation(CardGameEngineRuleStub())
    }

    func test_StopUpdates_IfGameIsOver() {
        // Given
        let ctx = Game {
            IsOver(true)
        }
        let event = MockEvent()
        let sut = CardGameEngine(ctx, queue: [event], rule: mockRule)
        let expectation = expectation(description: "event is processed")
        expectation.isInverted = true
        sut.state.sink { ctx in
            if case let .success(event) = ctx.event,
               event is MockEvent {
                expectation.fulfill()
            }
        }
        .store(in: &cancellables)

        // When
        sut.update()

        // Assert
        waitForExpectations(timeout: 0.1)
    }

    func test_QueueAnyInputMove_IfIdle() {
        // Given
        let ctx = Game {
            IsOver(false)
        }
        let move = MockEvent()
        let sut = CardGameEngine(ctx, rule: mockRule)
        let expectation = expectation(description: "move is queued")
        sut.state.sink { ctx in
            if case let .success(event) = ctx.event,
               event is MockEvent {
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
        let ctx = Game {}
        let move1 = Choose(actor: "p1", label: "c1")
        let move2 = Choose(actor: "p1", label: "c2")
        let blockingEvent = ChooseOne {
            move1
            move2
        }
        let sut = CardGameEngine(ctx, queue: [blockingEvent], rule: mockRule)
        let expectation = expectation(description: "move is queued")
        sut.state.sink { ctx in
            if case let .success(event) = ctx.event,
               event is Choose {
                expectation.fulfill()
            }
        }
        .store(in: &cancellables)

        // When
        sut.input(move1)

        // Assert
        waitForExpectations(timeout: 0.1)
    }

    func test_DoNotQueueMove_IfWaitingAndInvalid() {
        // Given
        let ctx = Game {}
        let blockingEvent = ChooseOne {
            Choose(actor: "p1", label: "c1")
            Choose(actor: "p1", label: "c2")
        }
        let sut = CardGameEngine(ctx, queue: [blockingEvent], rule: mockRule)
        let move = MockEvent()

        let expectation = expectation(description: "move is not queued")
        expectation.isInverted = true

        sut.state.sink { ctx in
            if case let .success(event) = ctx.event,
               event is MockEvent {
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

    // TODO: test emit active moves

    // TODO: test push triggered effects

    // TODO: test cancel queued effect
}

private struct MockEvent: Event {
    func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        .success(EventOutput(state: ctx))
    }
}
