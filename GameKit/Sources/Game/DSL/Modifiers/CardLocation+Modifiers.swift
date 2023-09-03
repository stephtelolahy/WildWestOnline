//
//  CardLocation+Modifiers.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

public extension CardLocation {

    init(cards: [String] = []) {
        self.cards = cards
    }

    init(visibility: String? = nil, @StringBuilder content: () -> [String] = { [] }) {
        self.visibility = visibility
        self.cards = content()
    }
}
