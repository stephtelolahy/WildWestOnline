//
//  SettingsCardsFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//
import Redux
import CardLibrary

/// Lists the collectible or ability cards of the library
public enum SettingsCardsFeature {
    public struct State: Equatable, Sendable {
        let kind: Kind
        public var cards: [Card]

        public enum Kind: Sendable {
            case collectibles
            case abilities
        }

        public struct Card: Equatable, Sendable {
            let name: String
            let description: String
        }

        public init(kind: Kind, cards: [Card] = []) {
            self.kind = kind
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
            let kind = state.kind
            state.cards = dependencies.cardLibrary.cards()
                .filter { kind == .abilities ? $0.type == .ability : $0.type == .collectible }
                .map { .init(name: $0.name, description: $0.description ?? "") }
        }

        return .none
    }
}
