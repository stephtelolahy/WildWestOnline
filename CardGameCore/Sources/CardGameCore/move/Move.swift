//
//  Move.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

/// Moves are actions a player chooses to take on their turn while nothing is happening
/// such as playing a card, using your Hero Power and ending your turn
public protocol Move: Event {
    
    var actor: String { get }
    
    func dispatch(in state: State) -> Result<MoveOutput, Error>
}

public struct MoveOutput {
    
    /// Updated state
    let state: State
    
    /// Child effects to be queued
    var effects: [Effect]?
    
    /// Context to transmit to all child effects
    var childCtx: [EffectKey: String]?
    
    /// Context to transmit to just next effect
    var nextCtx: [EffectKey: String]?
    
    public init(state: State,
                effects: [Effect]? = nil,
                childCtx: [EffectKey: String]? = nil,
                nextCtx: [EffectKey: String]? = nil) {
        self.state = state
        self.effects = effects
        self.childCtx = childCtx
        self.nextCtx = nextCtx
    }
}
