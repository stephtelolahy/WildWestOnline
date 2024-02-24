//
//  GameState+Inventory.swift
//  
//
//  Created by Hugues Telolahy on 25/04/2023.
//

import CardsRepository
import GameCore

extension GameState {
    static func makeBuilderWithCardRef() -> Builder {
        makeBuilder().withCardRef(CardList.all)
    }
}
