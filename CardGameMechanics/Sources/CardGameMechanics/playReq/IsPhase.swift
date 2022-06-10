//
//  IsPhase.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//
import CardGameCore

/// Must be on phase X and no playing hit
public struct IsPhase: PlayReq {
    
    let phase: Int
    
    public init(phase: Int) {
        self.phase = phase
    }
    
    public func verify(state: State, actor: String, card: Card) -> Result<Void, Error> {
        guard state.phase == phase else {
            return .failure(ErrorIsPhase(phase: phase))
        }
        
        return .success
    }
}
