//
//  Store.swift
//
//  Created by Stephano Hugues TELOLAHY on 02/11/2024.
//
import Combine

/// ``Reducer`` is a pure function that takes an action and the current state to calculate the new state.
/// Also executes side-effects in response, and eventually dispatch more actions
public typealias Reducer<State, Action, Dependencies> = (inout State, Action, Dependencies) throws -> Effect<Action>

public enum Effect<Action> {
    case none
    case publisher(AnyPublisher<Action, Never>)
    case run(() async -> Action)
}

/// ``Store`` is a base class that can be used to create the main store of an app, using the redux pattern.
/// It defines two roles of a "Store":
/// - receive/distribute `Action`;
/// - and publish changes of the the current app `State` to possible subscribers.
@MainActor public class Store<State, Action: Sendable, Dependencies>: ObservableObject {
    @Published public internal(set) var state: State
    public internal(set) var eventPublisher: PassthroughSubject<Action, Never>
    public internal(set) var errorPublisher: PassthroughSubject<Error, Never>

    private let reducer: Reducer<State, Action, Dependencies>
    private let dependencies: Dependencies

    public init(
        initialState: State,
        reducer: @escaping Reducer<State, Action, Dependencies> = { _, _, _ in .none },
        dependencies: Dependencies
    ) {
        self.state = initialState
        self.reducer = reducer
        self.dependencies = dependencies
        self.eventPublisher = .init()
        self.errorPublisher = .init()
    }

    public func dispatch(_ action: Action) async {
        do {
            let effect = try reducer(&state, action, dependencies)
            eventPublisher.send(action)
            switch effect {
            case .none:
                break

            case .publisher(let publisher):
                for await result in publisher.values {
                    await dispatch(result)
                }

            case .run(let asyncWork):
                let result = await asyncWork()
                await dispatch(result)
            }
        } catch {
            errorPublisher.send(error)
        }
    }
}
