//
//  GameData.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 18/01/2023.
//
import GameRules
import GameCards

enum AppState {
    static let game: Game = {
        let setup = SetupImpl()
        let inventory = InventoryImpl()
        let deck = inventory.getDeck()
        let figures = inventory.getFigures()
        let abilities = inventory.getAbilities()
        let ctx = setup.createGame(playersCount: 5, deck: deck, abilities: abilities, figures: figures)
        return ctx
    }()
}
