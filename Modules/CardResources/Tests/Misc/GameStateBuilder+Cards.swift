//
//  GameStateBuilder+Cards.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import GameFeature
@testable import CardResources

extension GameFeature.State.Builder {
    func withAllCards() -> Self {
        withCards(Cards.all.toDictionary)
    }

    func withDummyCards(_ names: [String]) -> Self {
        let dummyCards = names.reduce(into: [String: Card]()) { partialResult, element in
            partialResult[element] = .init(name: element, type: .collectible)
        }
        return withCards(dummyCards)
    }
}
