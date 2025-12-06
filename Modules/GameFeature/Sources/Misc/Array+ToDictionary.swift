//
//  Array+ToDictionary.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 02/11/2025.
//
import CardDefinition

public extension Array where Element == Card {
    var toDictionary: [String: Card] {
        reduce(into: [:]) { result, card in
            result[card.name] = card
        }
    }

    func names(for type: Card.CardType) -> [String] {
        filter { $0.type == type }.map(\.name)
    }
}
