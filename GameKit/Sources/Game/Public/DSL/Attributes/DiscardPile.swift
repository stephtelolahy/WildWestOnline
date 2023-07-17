//
//  DiscardPile.swift
//  
//
//  Created by Hugues Telolahy on 25/03/2023.
//

public struct DiscardPile: GameAttribute {
    let value: CardStack

    public init(@StringBuilder _ content: () -> [String]) {
        self.value = CardStack(content: content)
    }
    
    public func update(game: inout GameState) {
        game.discard = value
    }
}
