//
//  Cards.swift
//  Bang
//
//  Created by Hugues Telolahy on 28/10/2024.
//

/// BANG! THE BULLET
/// https://bang.dvgiochi.com/cardslist.php?id=2#q_result
public enum Cards {
    public static var all: [String: Card] {
        [
            stagecoach,
            wellsFargo,
            beer,
            saloon
        ].reduce(into: [:]) { result, card in
            result[card.name] = card
        }
    }
}

private extension Cards {
    static var stagecoach: Card {
        .init(
            name: .stagecoach,
            desc: "Draw two cards from the top of the deck.",
            onPlay: [
                .init(
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
            name: .wellsFargo,
            desc: "Draw three cards from the top of the deck.",
            onPlay: [
                .init(
                    action: .drawDeck,
                    selectors: [
                        .repeat(.value(3))
                    ]
                )
            ]
        )
    }

    static var beer: Card {
        .init(
            name: .beer,
            desc: "Regain one life point. Beer has no effect if there are only 2 players left in the game.",
            canPlay: [.playersAtLeast(3)],
            onPlay: [
                .init(
                    action: .heal,
                    selectors: [
                        .setAmount(1)
                    ]
                )
            ]
        )
    }

    static var saloon: Card {
        .init(
            name: .saloon,
            desc: "All players in play regain one life point.",
            onPlay: [
                .init(
                    action: .heal,
                    selectors: [
                        .setAmount(1),
                        .setTarget(.damaged)
                    ]
                )
            ]
        )
    }
}
