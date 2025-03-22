//
//  GameStateBuilder+Cards.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import GameCore
import CardsData

extension GameState {
    static func makeBuilderWithAllCards() -> Builder {
        makeBuilder()
            .withCards(Cards.all)
    }
}

extension GameState.Builder {
    func withDummyCards(_ names: [String]) -> Self {
        let dummyCards = names.reduce(into: [String: Card]()) { partialResult, element in
            partialResult[element] = .init(name: element)
        }
        return withCards(dummyCards)
    }
}
