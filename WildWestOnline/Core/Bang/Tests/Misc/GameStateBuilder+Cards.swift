//
//  GameStateBuilder+Cards.swift
//  BangTests
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import Bang

extension GameState {
    static func makeBuilderWithAllCards() -> Builder {
        makeBuilder().withCards(Cards.all)
    }
}

extension GameState.Builder {
    func withDummyCards(_ names: [String]) -> Self {
        let extraCards = names.reduce(into: [String: Card]()) { partialResult, element in
            partialResult[element] = .init(name: element)
        }
        return withCards(extraCards)
    }
}
