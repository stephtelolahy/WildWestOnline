//
//  CardsRepository.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 07/05/2024.
//
import GameCore

public class CardsRepository: InventoryService {
    public var inventory: Inventory {
        .init(
            cards: Cards.all,
            figures: Figures.bang,
            cardSets: CardSets.bang
        )
    }

    public init() {
    }
}
