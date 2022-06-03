//
//  PlayReq.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 30/05/2022.
//

/// Play condition based on current game state
public protocol PlayReq {
    func verify(ctx: State, actor: String, card: Card) -> PlayError?
}
