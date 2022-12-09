//
//  Effect.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

/// Elementary card effect
public protocol Effect {
 
    /// Resolving an effect will update game and may result in another effects
    func resolve(ctx: Game) -> Result<[Effect], Error>
}
