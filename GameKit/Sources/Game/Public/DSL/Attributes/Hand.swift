//
//  Hand.swift
//  
//
//  Created by Hugues Telolahy on 26/03/2023.
//

public struct Hand: PlayerAttribute {
    let value: CardLocation

    public init(@StringBuilder _ content: () -> [String]) {
        self.value = CardLocation(cards: content())
    }
    
    public func update(player: inout Player) {
        player.hand = value
    }
}
