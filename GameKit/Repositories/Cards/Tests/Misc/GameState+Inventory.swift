//
//  GameState+Inventory.swift
//  
//
//  Created by Hugues Telolahy on 25/04/2023.
//

import GameCore
import CardsRepository

extension GameState {
    static func makeBuilderWithCardRef() -> Builder {
        makeBuilder().withCardRef(CardList.all)
    }
}
