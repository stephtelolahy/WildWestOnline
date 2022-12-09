//
//  PlayReq.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

/// Elemenetary condition to play a card
public protocol PlayReq {
    
    func verify(ctx: Game) -> Result<Void, Error>
}
