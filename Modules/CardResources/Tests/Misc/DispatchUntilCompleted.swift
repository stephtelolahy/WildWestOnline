//
//  DispatchUntilCompleted.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import Testing
import Redux
import Combine
@testable import GameFeature
@testable import CardResources

typealias ChoiceHandler = ([String]) -> String

@MainActor
func dispatchUntilCompleted(
    _ action: GameFeature.Action,
    state: GameFeature.State,
    choiceHandler: @escaping ChoiceHandler = choiceHandlerFirstOption(),
    ignoreError: Bool = false
) async throws(GameFeature.Error) -> [GameFeature.Action] {
    // <registration>
    #warning("Move to feature setup")
    IncrementCardsPerTurnModifier.registerSelf()
    // </registration>

    let sut = Store(
        initialState: state,
        reducer: GameFeature.reducerCustom,
        dependencies: GameFeature.CustomDependencies(choiceHandler: choiceHandler)
    )
    var receivedActions: [GameFeature.Action] = []
    var receivedErrors: [GameFeature.Error] = []
    var cancellables: Set<AnyCancellable> = []
    sut.$state
        .sink { state in
            if let error = state.lastError {
                receivedErrors.append(error)
            }
            if let event = state.lastEvent {
                receivedActions.append(event)
            }
        }
        .store(in: &cancellables)

    // When
    await sut.dispatch(action)

    // Then
    if !ignoreError,
       !receivedErrors.isEmpty {
        throw receivedErrors[0]
    }

    return receivedActions
}

private extension GameFeature {

    struct CustomDependencies {
        let choiceHandler: ChoiceHandler
    }

    static var reducerCustom: Reducer<State, Action, CustomDependencies> {
        { state, action, dependencies in
            let mainEffect = reducer(&state, action, ())
            let choiceEffect = reducerChoice(&state, action, dependencies)
            return .group([mainEffect, choiceEffect])
        }
    }

    static var reducerChoice: Reducer<State, Action, CustomDependencies> {
        { state, action, dependencies in
            let state = state
            return .run {
                await performChoice(state: state, action: action, choiceHandler: dependencies.choiceHandler)
            }
        }
    }

    static func performChoice(
        state: State,
        action: Action,
        choiceHandler: ChoiceHandler
    ) async -> Action? {
        guard let pendingChoice = state.pendingChoice else {
            return nil
        }

        let selection = choiceHandler(pendingChoice.options.map(\.label))
        return GameFeature.Action.choose(selection, player: pendingChoice.chooser)
    }
}

func choiceHandlerFirstOption() -> ChoiceHandler {
    return { $0[0] }
}

func choiceHandlerWithResponses(_ responses: [ChoiceResponse]) -> ChoiceHandler {
    return { options in
        guard let matchingResponse = responses.first(where: { $0.options == options }) else {
            fatalError("Unexpected options: \(options)")
        }
        return matchingResponse.selection
    }
}

struct ChoiceResponse {
    let options: [String]
    let selection: String
}
