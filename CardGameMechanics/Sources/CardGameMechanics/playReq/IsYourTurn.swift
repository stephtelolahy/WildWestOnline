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
    
    public func verify(state: State, actor: String, card: Card) -> Result<Void, Error> {
        guard state.turn == actor else {
            return .failure(ErrorIsYourTurn())
        }
        
        return .success
    }
}
