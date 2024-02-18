//
//  Inventory.swift
//
//
//  Created by Hugues Telolahy on 11/07/2023.
//

import GameCore

public enum Inventory {
    public static func createGame(playersCount: Int) -> GameState {
        let figures = Array(CardList.figures.shuffled().prefix(playersCount))
        let deck = Setup.buildDeck(cardSets: CardSets.bang).shuffled()
        return Setup.buildGame(
            figures: figures,
            deck: deck,
            cardRef: CardList.all
        )
    }
}
