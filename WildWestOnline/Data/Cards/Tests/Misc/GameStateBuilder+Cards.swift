//
//  GameStateBuilder+Cards.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import GameCore
import CardsData

extension GameFeature.State {
    static func makeBuilderWithAllCards() -> Builder {
        makeBuilder()
            .withCards(Cards.all)
    }
}

extension GameFeature.State.Builder {
    func withDummyCards(_ names: [String]) -> Self {
        let dummyCards = names.reduce(into: [String: Card]()) { partialResult, element in
            partialResult[element] = .init(name: element)
        }
        return withCards(dummyCards)
    }
}
