//
//  GameState+Update.swift
//  
//
//  Created by Hugues Telolahy on 15/04/2023.
//

extension GameState {
    mutating func incrementPlayedThisTurn(for cardName: String) {
        playedThisTurn[cardName] = (playedThisTurn[cardName] ?? 0) + 1
    }
}
