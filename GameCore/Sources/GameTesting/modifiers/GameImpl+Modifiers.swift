//
//  GameImpl+Modifiers.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//
import GameCore

public extension GameImpl {
    
    /// initialize wirth active players
    static func create(_ activePlayers: Player...) -> Self {
        let playOrder = activePlayers.map(\.id)
        var players: [String: Player] = [:]
        activePlayers.forEach {
            players[$0.id] = $0
        }
        return .init(players: players, playOrder: playOrder)
    }
    
    func turn(_ value: String) -> Self {
        var copy = self
        copy.turn = value
        return copy
    }
    
    func deck(_ card: Card) -> Self {
        var copy = self
        copy.deck.append(card)
        return copy
    }
}
