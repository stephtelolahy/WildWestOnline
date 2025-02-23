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
    expectedChoices: [Choice] = []
) async throws -> [GameAction] {
    let sut = await createGameStoreWithSideEffects(initialState: state, expectedChoices: expectedChoices)
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

@MainActor private func createGameStoreWithSideEffects(
    initialState: GameState,
    expectedChoices: [Choice] = []
) -> Store<GameState, GameStoreDependencies> {
    .init(
        initialState: initialState,
        reducer: { state, action, dependencies in
                .group([
                    try gameReducer(state: &state, action: action, dependencies: ()),
                    try updateGameReducer(state: &state, action: action, dependencies: ()),
                    try performChoicesReducer(state: &state, action: action, dependencies: dependencies.choicesHolder)
                ])
        },
        dependencies: .init(choicesHolder: .init(choices: expectedChoices))
    )
}

private struct GameStoreDependencies {
    let choicesHolder: ChoicesHolder
}

struct Choice {
    let options: [String]
    let selectionIndex: Int
}

private class ChoicesHolder {
    var choices: [Choice]

    init(choices: [Choice]) {
        self.choices = choices
    }
}

private func performChoicesReducer(
    state: inout GameState,
    action: Action,
    dependencies: ChoicesHolder
) throws -> Effect {
    let state = state
    return .run {
        await performChoices(state: state, action: action, choicesHolder: dependencies)
    }
}

private func performChoices(
    state: GameState,
    action: Action,
    choicesHolder: ChoicesHolder
) async -> Action? {
    guard let pendingChoice = state.pendingChoice else {
        return nil
    }

    guard choicesHolder.choices.isNotEmpty else {
        fatalError("Unexpected choice: \(pendingChoice)")
    }

    guard pendingChoice.options.map(\.label) == choicesHolder.choices[0].options else {
        fatalError("Unexpected options: \(pendingChoice.options.map(\.label)) expected: \(choicesHolder.choices[0].options)")
    }

    let expectedChoice = choicesHolder.choices.remove(at: 0)
    let selection = pendingChoice.options[expectedChoice.selectionIndex]
    return GameAction.choose(selection.label, player: pendingChoice.chooser)
}
