//
//  GameStateBuilder+Cards.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import GameCore
import GameData

extension GameFeature.State {
    static func makeBuilderWithAllCards() -> Builder {
        makeBuilder()
            .withCards(Cards.all.toDictionary)
    }
}

extension GameFeature.State.Builder {
    func withDummyCards(_ names: [String]) -> Self {
        let dummyCards = names.reduce(into: [String: Card]()) { partialResult, element in
            partialResult[element] = .init(name: element, type: .playable)
        }
        return withCards(dummyCards)
    }
}
