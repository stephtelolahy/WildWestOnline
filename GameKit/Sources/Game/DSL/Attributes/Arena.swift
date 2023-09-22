//
//  Arena.swift
//  WildWestOnline
//
//  Created by Hugues Telolahy on 02/04/2023.
//

public struct Arena: GameAttribute {
    let value: CardLocation

    public init(@StringBuilder _ content: () -> [String]) {
        self.value = CardLocation(cards: content())
    }
    
    public func apply(to game: inout GameState) {
        game.arena = value
    }
}
