//
//  Store.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

/// Draw card from deck to store zone
public struct Store: Effect {
    
    public init() {}
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        var ctx = ctx
        let card = ctx.removeTopDeck()
        ctx.store.append(card)
        
        return .success(EffectOutputImpl(state: ctx))
    }
}
