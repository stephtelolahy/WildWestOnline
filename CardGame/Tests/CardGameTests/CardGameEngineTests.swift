//
//  EngineTests.swift
//
//
//  Created by Hugues Telolahy on 14/01/2023.
//

import XCTest
import Combine
import GameDSL
@testable import CardGame

class CardGameEngineTests: XCTestCase {

    private let mockRule = MockCardGameEngineRule()
    private var cancellables = Set<AnyCancellable>()

    func test_StopUpdates_IfGameIsOver() {
        // Given
        let ctx = Game {
            IsOver(true)
        }
        let queue: [Event] = [MockEvent()]
        let sut = CardGameEngine(ctx, queue: queue, rule: mockRule)
        let expectation = expectation(description: "move is queued")
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
/*
    func test_QueueAnyInputMove_IfIdle() {
        // Given
        let ctx = GameImpl()
        let sut = EngineImpl(ctx, rule: ruleMock)
        let move = MoveMock()
        let expectation = expectation(description: "move is queued")
        sut.state.sink { ctx in
            if case let .success(event) = ctx.event,
               event is MoveMock {
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
        let move = Choose(actor: "p1", label: "c1", children: [EffectMock()])
        let sut = EngineImpl(ctx, queue: [ChooseOne([move])], rule: ruleMock)
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
        let sut = EngineImpl(ctx, queue: [ChooseOne([move1])], rule: ruleMock)
        let move = MoveMock()

        let expectation = expectation(description: "move is not queued")
        expectation.isInverted = true

        sut.state.sink { ctx in
            if case let .success(event) = ctx.event,
               event is MoveMock {
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
*/
    // TODO: test emit active moves

    // TODO: test push triggered effects

    // TODO: test cancel queued effect
}

private struct MockCardGameEngineRule: CardGameEngineRule {

    func triggered(_ ctx: Game) -> [Event]? {
        nil
    }

    func active(_ ctx: Game) -> [Event]? {
        nil
    }
}

private struct MockEvent: Event {
    func resolve(_ ctx: GameDSL.Game) -> Result<GameDSL.EventOutput, Error> {
        .success(EventOutput())
    }
}
