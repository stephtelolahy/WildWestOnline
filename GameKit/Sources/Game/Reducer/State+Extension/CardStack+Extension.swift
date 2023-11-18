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

    mutating func remove(_ card: String) throws {
        guard let index = cards.firstIndex(where: { $0 == card }) else {
            throw GameError.cardNotFound(card)
        }

        cards.remove(at: index)
    }
}
