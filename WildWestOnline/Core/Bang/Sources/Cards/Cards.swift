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
            wellsFargo
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
}
