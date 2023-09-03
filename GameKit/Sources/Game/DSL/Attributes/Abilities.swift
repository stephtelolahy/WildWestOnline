//
//  Abilities.swift
//  
//
//  Created by Hugues Telolahy on 29/03/2023.
//

public struct Abilities: PlayerAttribute {
    let value: [String]

    public init(@StringBuilder _ content: () -> [String]) {
        self.value = content()
    }
    
    public func update(player: inout Player) {
        player.abilities = value
    }
}
