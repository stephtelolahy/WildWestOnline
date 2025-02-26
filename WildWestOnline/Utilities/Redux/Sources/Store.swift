//
//  Store.swift
//
//  Created by Stephano Hugues TELOLAHY on 02/11/2024.
//
import Combine

/// ``Action`` is a plain object that describes what happened.
/// To change something in the state, you need to dispatch an action.
/// Common protocol to which all actions conform.
///
public protocol Action: Sendable {}

/// ``Reducer`` is a pure function that takes an action and the current state to calculate the new state.
/// Also return side-effects in response, and eventually dispatch more actions
public typealias Reducer<State, Dependencies> = (inout State, Action, Dependencies) throws -> Effect

/// ``Effect`` is an asynchronous `Action`
public enum Effect {
    case none
    case publisher(AnyPublisher<Action, Never>)
    case run(() async -> Action?)
    case group([Effect])
}

/// ``Store`` is a base class that can be used to create the main store of an app, using the redux pattern.
/// It defines two roles of a "Store":
/// - receive/distribute `Action`;
/// - and publish changes of the the current app `State` to possible subscribers.
@MainActor public class Store<State, Dependencies>: ObservableObject {
    @Published public internal(set) var state: State
    public internal(set) var eventPublisher: PassthroughSubject<Action, Never>
    public internal(set) var errorPublisher: PassthroughSubject<Error, Never>
    
    private let reducer: Reducer<State, Dependencies>

    /// The dependencies are passed explicitly and are injected at store creation,
    /// and each view or reducer gets access to only the specific dependencies it is working with
    private let dependencies: Dependencies
    
    public init(
        initialState: State,
        reducer: @escaping Reducer<State, Dependencies> = { _, _, _ in .none },
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
            await runEffect(effect)
        } catch {
            errorPublisher.send(error)
        }
    }

    private func runEffect(_ effect: Effect) async {
        switch effect {
        case .none:
            return

        case .publisher(let publisher):
            for await result in publisher.values {
                await dispatch(result)
            }

        case .run(let asyncWork):
            if let result = await asyncWork() {
                await dispatch(result)
            }

        case .group(let effects):
            for subEffect in effects {
                await runEffect(subEffect)
            }
        }
    }
}
