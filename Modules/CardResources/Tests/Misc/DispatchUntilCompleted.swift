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
import CardResources

typealias ChoiceHandler = ([String]) -> String

@MainActor
func dispatchUntilCompleted(
    _ action: GameFeature.Action,
    state: GameFeature.State,
    choiceHandler: @escaping ChoiceHandler = choiceHandlerFirstOption(),
    ignoreError: Bool = false
) async throws(GameFeature.Error) -> [GameFeature.Action] {
    var dependencies = Dependencies()
    dependencies.queueModifierClient = .live(handlers: QueueModifiers.allHandlers)
    dependencies.choiceHandler = .init(handleChoice: choiceHandler)
    let sut = Store(
        initialState: state,
        reducer: combine(GameFeature.reducer, GameFeature.reducerChoice),
        dependencies: dependencies
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

    sut.dispatchedAction
        .sink { action in
            print(action)
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
    static var reducerChoice: Reducer<State, Action> {
        { state, action, dependencies in
            let state = state
            return .run {
                guard let pendingChoice = state.pendingChoice else {
                    return nil
                }

                let selection = dependencies.choiceHandler.handleChoice(pendingChoice.options.map(\.label))
                return GameFeature.Action.choose(selection, player: pendingChoice.chooser)
            }
        }
    }
}

private func choiceHandlerFirstOption() -> ChoiceHandler {
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

private struct ChoiceHandlerClient {
    var handleChoice: ChoiceHandler
}

private extension Dependencies {
    var choiceHandler: ChoiceHandlerClient {
        get { self[ChoiceHandlerClientKey.self] }
        set { self[ChoiceHandlerClientKey.self] = newValue }
    }
}

private enum ChoiceHandlerClientKey: DependencyKey {
    nonisolated(unsafe) static let defaultValue: ChoiceHandlerClient = .noop
}

private extension ChoiceHandlerClient {
    static var noop: Self {
        .init(
            handleChoice: { $0[0] }
        )
    }
}
