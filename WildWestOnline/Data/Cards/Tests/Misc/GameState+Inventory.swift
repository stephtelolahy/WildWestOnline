//
//  GameState+Inventory.swift
//  
//
//  Created by Hugues Telolahy on 25/04/2023.
//

import CardsData
import GameCore

extension GameState {
    static func makeBuilderWithCards() -> Builder {
        makeBuilder().withCards(CardsRepository().inventory.cards)
    }
}
