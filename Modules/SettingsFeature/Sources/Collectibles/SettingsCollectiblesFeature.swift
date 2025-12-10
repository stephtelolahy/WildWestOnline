//
//  SettingsCollectiblesFeature.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//
import Redux
import CardLibrary

public enum SettingsCollectiblesFeature {
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
            state.cards = dependencies.loadCollectibleCards()
        }

        return .none
    }
}

private extension Dependencies {
    func loadCollectibleCards() -> [SettingsCollectiblesFeature.State.Card] {
        cardLibrary.cards()
            .filter { $0.type == .collectible }
            .map {
                .init(
                    name: $0.name,
                    description: $0.description ?? ""
                )
            }
    }
}
