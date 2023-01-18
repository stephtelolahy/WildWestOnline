//
//  GameData.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 18/01/2023.
//
import Bang

enum AppState {
    static let game: Game = {
        let setup = SetupImpl()
        let inventory = InventoryImpl()
        let deck = inventory.getDeck()
        let abilities = inventory.getAbilities()
        let ctx = setup.createGame(playersCount: 7, deck: deck, abilities: abilities)
        return ctx
    }()
}
