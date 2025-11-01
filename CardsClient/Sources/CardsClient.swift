//
//  CardsClient.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 01/11/2025.
//
import GameFeature

public struct CardsClient {
    public var loadCards: () -> [Card]
    public var loadDeck: () -> [String: [String]]

    public init(
        loadCards: @escaping () -> [Card],
        loadDeck: @escaping () -> [String: [String]]
    ) {
        self.loadCards = loadCards
        self.loadDeck = loadDeck
    }
}
