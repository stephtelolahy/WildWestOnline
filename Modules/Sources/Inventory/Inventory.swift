//
//  Inventory.swift
//  
//
//  Created by Hugues Telolahy on 11/07/2023.
//
import Game

public enum Inventory {
    public static func createGame(playersCount: Int) -> GameState {
        let figures = Array(FigureList.all.shuffled().prefix(playersCount))
        let deck = Setup.createDeck(cardSets: CardSets.bang)
        let game = Setup.createGame(figures: figures, abilities: AbilityList.default, deck: deck)
            .cardRef(CardList.all)
        return game
    }
}
