//
//  DispatchUntilCompleted.swift
//  BangTests
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import Testing
import XCTest
import Redux
import Combine
import GameCore

func dispatchUntilCompleted(
    _ action: GameAction,
    state: GameState,
    expectedChoices: [Choice] = [],
    file: StaticString = #file,
    line: UInt = #line
) async throws -> [GameAction] {
    let sut = await createGameStoreWithSideEffects(initialState: state)
    var receivedActions: [Action] = []
    var receivedErrors: [Error] = []
    var cancellables: Set<AnyCancellable> = []
    await MainActor.run {
        sut.eventPublisher
            .sink { receivedActions.append($0) }
            .store(in: &cancellables)
        sut.errorPublisher
            .sink { receivedErrors.append($0) }
            .store(in: &cancellables)
    }

    // When
    await sut.dispatch(action)

    // Then
    guard receivedErrors.isEmpty else {
        throw receivedErrors[0]
    }

    let gameActions = receivedActions.compactMap { action in
        if let action = action as? GameAction,
            action.isRenderable {
            return action
        } else {
            return nil
        }
    }

    return gameActions
}

@MainActor private func createGameStoreWithSideEffects(initialState: GameState) -> Store<GameState, Void> {
    .init(
        initialState: initialState,
        reducer: { state, action, dependencies in
                .group([
                    try gameReducer(state: &state, action: action, dependencies: dependencies),
                    try updateGameReducer(state: &state, action: action, dependencies: dependencies)
                ])
        },
        dependencies: ()
    )
}

struct Choice {
    let options: [String]
    let selectionIndex: Int
}

private class ChoicesWrapper {
    var choices: [Choice]

    init(choices: [Choice]) {
        self.choices = choices
    }
}
/*
private extension Middlewares {
    static func performChoices(_ expectedChoicesWrapper: ChoicesWrapper) -> Middleware<GameState> {
        { state, _ in
            guard let pendingChoice = state.pendingChoice else {
                return nil
            }

            guard expectedChoicesWrapper.choices.isNotEmpty else {
                fatalError("Unexpected choice: \(pendingChoice)")
            }

            guard pendingChoice.options.map(\.label) == expectedChoicesWrapper.choices[0].options else {
                fatalError("Unexpected options: \(pendingChoice.options.map(\.label)) expected: \(expectedChoicesWrapper.choices[0].options)")
            }

            let expectedChoice = expectedChoicesWrapper.choices.remove(at: 0)
            let selection = pendingChoice.options[expectedChoice.selectionIndex]
            return GameAction.choose(selection.label, player: pendingChoice.chooser)
        }
    }
}
*/
