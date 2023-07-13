//
//  Player+GameAttribute.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 26/04/2023.
//

extension Player: GameAttribute {
    public func update(game: inout GameState) {
        game.setupOrder.append(id)
        game.playOrder.append(id)
        game.players[id] = self
    }
}
