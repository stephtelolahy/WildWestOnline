//
//  DispatchUntilCompleted.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import Testing
import Redux
import Combine
import GameFeature

struct Choice {
    let options: [String]
    let selectionIndex: Int
}

@MainActor
func dispatchUntilCompleted(
    _ action: GameFeature.Action,
    state: GameFeature.State,
    expectedChoices: [Choice] = []
) async throws(GameFeature.Error) -> [GameFeature.Action] {
    let sut = Store(
        initialState: state,
        reducer: GameFeature.reducerTest,
        dependencies: GameFeature.TestDependencies(choicesHolder: .init(choices: expectedChoices))
    )
    var receivedActions: [GameFeature.Action] = []
    var receivedErrors: [GameFeature.Error] = []
    var cancellables: Set<AnyCancellable> = []
    sut.$state
        .sink { state in
            if let error = state.lastActionError {
                receivedErrors.append(error)
            }
            if let event = state.lastSuccessfulAction {
                receivedActions.append(event)
            }
        }
        .store(in: &cancellables)

    // When
    await sut.dispatch(action)

    // Then
    if !receivedErrors.isEmpty {
        throw receivedErrors[0]
    }

    return receivedActions
}

private extension GameFeature {

    struct TestDependencies {
        let choicesHolder: ChoicesHolder
    }

    class ChoicesHolder {
        var choices: [Choice]

        init(choices: [Choice]) {
            self.choices = choices
        }
    }

    static var reducerTest: Reducer<State, Action, TestDependencies> {
        { state, action, dependencies in
            let mainEffect = reducer(&state, action, ())
            let choiceEffect = reducerChoice(&state, action, dependencies)
            return .group([mainEffect, choiceEffect])
        }
    }

    static var reducerChoice: Reducer<State, Action, TestDependencies> {
        { state, action, dependencies in
            let state = state
            return .run {
                await performChoice(state: state, action: action, choicesHolder: dependencies.choicesHolder)
            }
        }
    }

    static func performChoice(
        state: State,
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
        return GameFeature.Action.choose(selection.label, player: pendingChoice.chooser)
    }
}
