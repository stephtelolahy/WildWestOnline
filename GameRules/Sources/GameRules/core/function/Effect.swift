//
//  Effect.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

/// Elementary card effect
/// Function that causes any change in the game state
public protocol Effect: Event {
    
    /// Context data for resolving
    var playCtx: PlayContext { get set }
}

public protocol PlayContext {
    
    /// current actor
    var actor: String { get }
    
    /// played card
    var playedCard: Card { get }
    
    /// target
    var target: String? { get set }
}
