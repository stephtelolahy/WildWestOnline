//
//  IsYourTurn.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

/// Must be your turn
public class IsYourTurn: PlayReq {
    
    public init() {}
    
    public func verify(ctx: State, actor: String, card: Card) -> Result<Void, Error> {
        if ctx.turn == actor {
            return .success
        } else {
            return .failure(ErrorIsYourTurn())
        }
    }
}
