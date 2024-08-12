//
//  Card.swift
//
//
//  Created by Hugues Telolahy on 12/08/2024.
//
// swiftlint:disable no_magic_numbers

public class Inventory {
    var cards: [String: Card] = [:]

    func registerAllCards() {
        cards["beer"] = beer
    }
}

extension Inventory {
    /// Regain one life point.
    /// Beer has no effect if there are only 2 players left in the game.
    var beer: Card {
        [
            .brown,
            .init(
                when: .played,
                action: .heal,
                selectors: [
                    .if(.playersAtLeast(3))
                ]
            )
        ]
    }
}
