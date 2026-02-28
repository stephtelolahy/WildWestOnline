//
//  SettingsAbilitiesFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 28/02/2026.
//

import Redux
import CardLibrary

public enum SettingsAbilitiesFeature {
    public struct State: Equatable, Sendable {
        public var cards: [Card]

        public struct Card: Equatable, Sendable {
            let name: String
            let description: String
        }

        public init(cards: [Card] = []) {
            self.cards = cards
        }
    }

    public enum Action {
        case didAppear
    }

    static func reducer(
        state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        switch action {
        case .didAppear:
            state.cards = dependencies.loadAbilityCards()
        }

        return .none
    }
}

private extension Dependencies {
    func loadAbilityCards() -> [SettingsAbilitiesFeature.State.Card] {
        cardLibrary.cards()
            .filter { $0.type == .ability }
            .map {
                .init(
                    name: $0.name,
                    description: $0.description ?? ""
                )
            }
    }
}
