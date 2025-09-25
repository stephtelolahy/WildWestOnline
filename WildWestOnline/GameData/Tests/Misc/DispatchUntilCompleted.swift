//
//  DispatchUntilCompleted.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import Testing
import Redux
import Combine
import GameCore

func dispatchUntilCompleted(
    _ action: GameFeature.Action,
    state: GameFeature.State,
    expectedChoices: [Choice] = []
) async throws(Card.PlayError) -> [GameFeature.Action] {
    let sut = await createGameStore(initialState: state, expectedChoices: expectedChoices)
    let collector = ActionCollector()
    var cancellables: Set<AnyCancellable> = []
    await MainActor.run {
        sut.$state
            .sink { state in
                Task {
                    await collector.append(from: state)
                }
            }
            .store(in: &cancellables)
    }

    // When
    await sut.dispatch(action)

    // Then
    let snapshot = await collector.snapshot()
    guard snapshot.errors.isEmpty else {
        throw snapshot.errors[0]
    }

    return snapshot.actions
}

@MainActor private func createGameStore(
    initialState: GameFeature.State,
    expectedChoices: [Choice] = []
) -> Store<GameFeature.State, GameStoreDependencies> {
    .init(
        initialState: initialState,
        reducer: { state, action, dependencies in
                .group([
                    GameFeature.reduce(into: &state, action: action, dependencies: ()),
                    performChoicesReducer(state: &state, action: action, dependencies: dependencies.choicesHolder)
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

private actor ActionCollector {
    private var actions: [GameFeature.Action] = []
    private var errors: [Card.PlayError] = []

    func append(from state: GameFeature.State) {
        if let error = state.lastActionError {
            errors.append(error)
        }
        if let event = state.lastSuccessfulAction {
            actions.append(event)
        }
    }

    func snapshot() -> (actions: [GameFeature.Action], errors: [Card.PlayError]) {
        (actions, errors)
    }
}

private func performChoicesReducer(
    state: inout GameFeature.State,
    action: ActionProtocol,
    dependencies: ChoicesHolder
) -> Effect {
    let state = state
    return .run {
        await performChoices(state: state, action: action, choicesHolder: dependencies)
    }
}

private func performChoices(
    state: GameFeature.State,
    action: ActionProtocol,
    choicesHolder: ChoicesHolder
) async -> ActionProtocol? {
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
