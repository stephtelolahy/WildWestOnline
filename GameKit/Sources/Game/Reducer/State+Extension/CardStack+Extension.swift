//
//  CardStack+Extension.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

extension CardStack {

    mutating func push(_ card: String) {
        cards.insert(card, at: 0)
    }

    mutating func pop() -> String {
        cards.removeFirst()
    }
}
