//
//  Inventory.swift
//  
//
//  Created by Hugues Telolahy on 11/07/2023.
//
import Game

public enum Inventory {
    public static func createGame(playersCount: Int) -> GameState {
        let figures = Array(CardList.figures.shuffled().prefix(playersCount))
        let deck = Setup.buildDeck(cardSets: CardSets.bang)
        var game = Setup.buildGame(figures: figures,
                                   defaultAttributes: GameDefault.attributes,
                                   defaultAbilities: GameDefault.abilities,
                                   deck: deck)
        game.cardRef = CardList.all
        return game
    }
}
