//
//  SettingsFiguresFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//

import Redux
import CardLibrary

public enum SettingsFiguresFeature {
    public struct State: Equatable, Sendable {
        var figures: [Figure]

        public struct Figure: Equatable, Sendable {
            let name: String
            let description: String
            let isFavorite: Bool
        }

        public init(figures: [Figure] = []) {
            self.figures = figures
        }
    }

    public enum Action {
        case onAppear
        case selected(String)
    }

    static func reducer(
        state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.figures = dependencies.cardLibrary.cards()
                .filter { $0.type == .figure }
                .map {
                    .init(
                        name: $0.name,
                        description: $0.description ?? "",
                        isFavorite: $0.name == dependencies.preferencesClient.preferredFigure()
                    )
                }

        case .selected(let name):
            dependencies.preferencesClient.setPreferredFigure(name)
        }

        return .none
    }
}
