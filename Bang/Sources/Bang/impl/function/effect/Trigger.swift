//
//  Trigger.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//

/// Move
/// Trigger a card
public struct Trigger: Effect, Equatable {
    private let actor: String
    private let card: String
    
    public init(actor: String, card: String) {
        self.actor = actor
        self.card = card
    }
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        var ctx = ctx
        let playerObj = ctx.player(actor)
        
        /// find card reference
        let cardObj: Card
        if let abilityIndex = playerObj.abilities.firstIndex(where: { $0.id == card }) {
            cardObj = playerObj.abilities[abilityIndex]
            
        } else {
            fatalError(.missingPlayerCard(card))
        }
        
        /// set playing data
        ctx.currentActor = actor
        ctx.currentCard = cardObj
        
        /// push child effects
        let children = cardObj.onTrigger
        
        return .success(EffectOutputImpl(state: ctx, effects: children))
    }
}
