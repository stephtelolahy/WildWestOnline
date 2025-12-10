//
//  SettingsFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 04/12/2025.
//

import Redux

public enum SettingsFeature {
    public struct State: Equatable {
        var path: [Destination]

        var home: SettingsHomeFeature.State
        var figures: SettingsFiguresFeature.State?
        var collectibles: SettingsCollectiblesFeature.State?

        public enum Destination: Hashable, Sendable {
            case figures
            case collectibles
        }

        public init(
            path: [Destination] = [],
            home: SettingsHomeFeature.State = .init(),
            figures: SettingsFiguresFeature.State? = nil,
            collectibles: SettingsCollectiblesFeature.State? = nil
        ) {
            self.path = path
            self.home = home
            self.figures = figures
            self.collectibles = collectibles
        }
    }

    public enum Action {
        // View
        case setPath([State.Destination])

        // Internal
        case home(SettingsHomeFeature.Action)
        case figures(SettingsFiguresFeature.Action)
        case collectibles(SettingsCollectiblesFeature.Action)
    }

    public static var reducer: Reducer<State, Action> {
        combine(
            reducerMain,
            pullback(
                SettingsHomeFeature.reducer,
                state: { _ in
                    \.home
                },
                action: { globalAction in
                    if case let .home(localAction) = globalAction {
                        return localAction
                    }
                    return nil
                },
                embedAction: {
                    .home($0)
                }
            ),
            pullback(
                SettingsFiguresFeature.reducer,
                state: {
                    $0.figures != nil ? \.figures! : nil
                },
                action: { globalAction in
                    if case let .figures(localAction) = globalAction {
                        return localAction
                    }
                    return nil
                },
                embedAction: {
                    .figures($0)
                }
            ),
            pullback(
                SettingsCollectiblesFeature.reducer,
                state: {
                    $0.collectibles != nil ? \.collectibles! : nil
                },
                action: { globalAction in
                    if case let .collectibles(localAction) = globalAction {
                        return localAction
                    }
                    return nil
                },
                embedAction: {
                    .collectibles($0)
                }
            )
        )
    }

    private static func reducerMain(
        into state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        switch action {
        case .setPath(let path):
            state.path = path
            if path.contains(.figures) && state.figures == nil {
                state.figures = .init()
            }
            if !path.contains(.figures) && state.figures != nil {
                state.figures = nil
            }
            if path.contains(.collectibles) && state.collectibles == nil {
                state.collectibles = .init()
            }
            if !path.contains(.collectibles) && state.collectibles != nil {
                state.collectibles = nil
            }
            return .none

        case .home(.delegate(.selectedCollectibles)):
            return .run { .setPath([.collectibles]) }

        case .home(.delegate(.selectedFigures)):
            return .run { .setPath([.figures]) }

        case .home:
            return .none

        case .figures:
            return .none

        case .collectibles:
            return .none
        }
    }
}
