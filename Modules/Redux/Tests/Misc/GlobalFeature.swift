//
//  GlobalFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//
import Redux

enum GlobalFeature {
    struct State: Equatable {
        var counter = CounterFeature.State()
        var flag = FlagFeature.State()
    }

    enum Action: Equatable {
        case counter(CounterFeature.Action)
        case flag(FlagFeature.Action)
    }

    static var reducer: Reducer<State, Action> {
        combine(
            pullback(
                CounterFeature.reducer,
                state: { _ in \.counter },
                action: { if case let .counter(action) = $0 { action } else { nil } },
                embedAction: Action.counter
            ),
            pullback(
                FlagFeature.reducer,
                state: { _ in \.flag },
                action: { if case let .flag(action) = $0 { action } else { nil } },
                embedAction: Action.flag
            )
        )
    }
}

enum CounterFeature {
    struct State: Equatable { var count = 0 }

    enum Action: Equatable {
        case increment
        case decrement
        case asyncIncrement
        case incremented(Int)
    }

    static func reducer(state: inout State, action: Action, dependencies: Dependencies) -> Effect<Action> {
        switch action {
        case .increment:
            state.count += dependencies.stepClient.step()
            return .none

        case .decrement:
            state.count -= dependencies.stepClient.step()
            return .none

        case .asyncIncrement:
            return .run {
                try? await Task.sleep(nanoseconds: 100_000_000)
                return .incremented(1)
            }

        case .incremented(let delta):
            state.count += delta
            return .none
        }
    }
}

enum FlagFeature {
    struct State: Equatable { var isOn = false }

    enum Action: Equatable {
        case toggle
    }

    static func reducer(state: inout State, action: Action, dependencies: Dependencies) -> Effect<Action> {
        switch action {
        case .toggle:
            state.isOn.toggle()
            return .none
        }
    }
}
