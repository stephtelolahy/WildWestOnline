//
//  Store.swift
//
//  Created by Stephano Hugues TELOLAHY on 02/11/2024.
//
import Combine

/// ``Reducer`` is a pure function that takes an action and the current state to calculate the new state.
/// Also return side-effects in response, and eventually dispatch more actions
public typealias Reducer<State, Action> = (inout State, Action, Dependencies) -> Effect<Action>

/// ``Effect`` is an asynchronous `Action`
public enum Effect<Action> {
    // swiftlint:disable:next discouraged_none_name
    case none
    case send(Action)
    case run(() async -> Action?)
    case publisher(AnyPublisher<Action, Never>)
    case group([Effect<Action>])
}

public struct Dependencies {
    private var storage: [ObjectIdentifier: Any] = [:]

    public init() {}

    public subscript<K: DependencyKey>(key: K.Type) -> K.Value {
        get { storage[ObjectIdentifier(key)] as? K.Value ?? K.defaultValue }
        set { storage[ObjectIdentifier(key)] = newValue }
    }
}

public protocol DependencyKey {
    associatedtype Value

    static var defaultValue: Value { get }
}

/// ``Store`` is a base class that can be used to create the main store of an app, using the redux pattern.
/// It defines two roles of a "Store":
/// - receive/distribute `Action`;
/// - and publish changes of the the current app `State` to possible subscribers.
@MainActor
public class Store<State, Action>: ObservableObject {
    @Published public internal(set) var state: State
    public internal(set) var dispatchedAction = PassthroughSubject<Action, Never>()

    private let reducer: Reducer<State, Action>
    internal let dependencies: Dependencies

    public init(
        initialState: State,
        reducer: @escaping Reducer<State, Action> = { _, _, _ in .none },
        withDependencies prepareDependencies: (inout Dependencies) -> Void = { _ in },
    ) {
        self.state = initialState
        self.reducer = reducer
        var dependencies = Dependencies()
        prepareDependencies(&dependencies)
        self.dependencies = dependencies
    }

    /// Reduces `action` then runs the returned effect, and every action it produces, until nothing is left.
    /// Actions are handled depth-first, in the order effects produce them,
    /// using an explicit work stack rather than recursion,
    /// so a long chain of actions (e.g. a whole game) does not nest one async call per action.
    public func dispatch(_ action: Action) async {
        var stack: [Work] = [.action(action)]
        while let work = stack.popLast() {
            switch work {
            case .action(let action):
                let effect = reducer(&state, action, dependencies)
                dispatchedAction.send(action)
                stack.append(.effect(effect))

            case .effect(let effect):
                stack.append(contentsOf: await pendingWork(of: effect))
            }
        }
    }

    /// Work left to do, in stack order: the last element is handled first.
    private func pendingWork(of effect: Effect<Action>) async -> [Work] {
        switch effect {
        case .none:
            return []

        case .send(let action):
            return [.action(action)]

        case .run(let asyncWork):
            guard let result = await asyncWork() else {
                return []
            }
            return [.action(result)]

        case .publisher(let publisher):
            // Each emitted value is fully handled before the next one is awaited
            for await result in publisher.values {
                await dispatch(result)
            }
            return []

        case .group(let effects):
            return effects.reversed().map { .effect($0) }
        }
    }

    private enum Work {
        case action(Action)
        case effect(Effect<Action>)
    }
}
