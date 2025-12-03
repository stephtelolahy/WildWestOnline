//
//  SettingsFiguresFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//

import Redux
import CardLibrary

enum SettingsFiguresFeature {
    struct State: Equatable, Codable, Sendable {
        var figures: [Figure]

        struct Figure: Equatable, Codable, Sendable {
            let name: String
            let description: String
            let isFavorite: Bool
        }
    }

    enum Action {
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
            dependencies.preferencesClient.savePreferredFigure(name)
        }

        return .none
    }
}
