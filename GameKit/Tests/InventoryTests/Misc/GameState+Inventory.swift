//
//  GameState+Inventory.swift
//  
//
//  Created by Hugues Telolahy on 25/04/2023.
//

import Game
import Inventory

func createGameWithCardRef(@GameAttributeBuilder components: () -> [GameAttribute]) -> GameState {
    var game = GameState(components: components)
    game.cardRef = CardList.all
    return game
}

extension GameState {
    static func makeBuilderWithCardRef() -> Builder {
        makeBuilder().withCardRef(CardList.all)
    }
}
