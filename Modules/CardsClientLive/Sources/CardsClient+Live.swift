//
//  CardsClient+Live.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 01/11/2025.
//

import CardsClient

public extension CardsClient {
    static func live() -> Self {
        .init(
            loadCards: { Cards.all },
            loadDeck: { Deck.bang }
        )
    }
}
