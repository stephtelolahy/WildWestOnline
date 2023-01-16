//
//  Effect.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 09/12/2022.
//

/// Elementary card effect
public protocol Effect {
    
    /// Context while resolving
    // swiftlint:disable:next implicitly_unwrapped_optional
    var playCtx: PlayContext! { get set }
    
    func resolve(_ ctx: Game) -> Result<EffectOutput, GameError>
}

/// Resolving an effect may update game or push another effects
public protocol EffectOutput {
    
    /// Updated `State`
    var state: Game? { get }
    
    /// Child effect on resolving arguments
    var effects: [Effect]? { get }
    
    /// Waiting user action
    var options: [Effect]? { get }
}

public protocol PlayContext {
    
    /// current actor
    var actor: String { get }
    
    /// played card
    var playedCard: Card { get }
    
    /// target
    var target: String? { get set }
}
