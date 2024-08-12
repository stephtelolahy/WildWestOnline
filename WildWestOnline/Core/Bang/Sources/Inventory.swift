//
//  Inventory.swift
//  
//
//  Created by Hugues Telolahy on 12/08/2024.
//

// swiftlint:disable no_magic_numbers

/// We are working on a Card Definition Language that will allow people to create new cards,
/// not currently in the game and see how they play.
/// A `card` is just a collection of effects using `Tag system`
/// Inspired by https://github.com/danielyule/hearthbreaker/wiki/Tag-Format
///
public enum Inventory {
    public struct Card: Equatable, Codable {
        public let id: String
        public let desc: String
        public let effects: [Effect]
    }

    static var cards: [Card] = [
        beer,
        saloon,
        stagecoach,
        wellsFargo,
        catBalou
    ]
}

extension Inventory {
    static var beer: Card {
        .init(
            id: "beer",
            desc: "Regain one life point. Beer has no effect if there are only 2 players left in the game.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .heal,
                    selectors: [
                        .if(.playersAtLeast(3))
                    ]
                )
            ]
        )
    }

    static var saloon: Card {
        .init(
            id: "saloon",
            desc: "All players in play regain one life point.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .heal,
                    selectors: [
                        .target(.all)
                    ]
                )
            ]
        )
    }

    static var stagecoach: Card {
        .init(
            id: "stagecoach",
            desc: "Draw two cards from the top of the deck.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .drawDeck,
                    selectors: [
                        .repeat(.value(2))
                    ]
                )
            ]
        )
    }

    static var wellsFargo: Card {
        .init(
            id: "wellsFargo",
            desc: "Draw three cards from the top of the deck.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .drawDeck,
                    selectors: [
                        .repeat(.value(3))
                    ]
                )
            ]
        )
    }

    static var catBalou: Card {
        .init(
            id: "catBalou",
            desc: "Force “any one player” to “discard a card”, regardless of the distance.",
            effects: [
                .brown,
                .init(
                    when: .played,
                    action: .discard,
                    selectors: [
                        .chooseTarget([.havingCard]),
                        .chooseCard()
                    ]
                )
            ]
        )
    }
}
