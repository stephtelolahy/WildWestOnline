//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

public struct Player {
    
    /// player name
    public var name: String = ""
    
    /// max health
    public var maxHealth: Int = 0
    
    /// current health
    public var health: Int = 0
    
    /// built-in cards
    public var common: [Card] = []
    
    /// hand cards
    public var hand: [Card] = []
    
    /// in play cards
    public var inPlay: [Card] = []
}
