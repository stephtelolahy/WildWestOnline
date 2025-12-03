//
//  SettingsCollectiblesFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//
import Redux
import CardLibrary

public enum SettingsCollectiblesFeature {
    public struct State: Equatable, Codable, Sendable {
        var cards: [Card]

        struct Card: Equatable, Codable, Sendable {
            let name: String
            let description: String
        }
    }

    public enum Action {
        case onAppear
    }

    static func reducer(
        state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        switch action {
        case .onAppear:
            state.cards = dependencies.cardLibrary.cards()
                .filter { $0.type == .collectible }
                .map {
                    .init(
                        name: $0.name,
                        description: $0.description ?? ""
                    )
                }
        }

        return .none
    }
}
