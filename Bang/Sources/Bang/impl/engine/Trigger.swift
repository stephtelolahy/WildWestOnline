//
//  Trigger.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//

/// Trigger a card after an event occured
public struct Trigger: Move, Equatable {
    public let actor: String
    private let card: String
    
    public init(actor: String, card: String) {
        self.actor = actor
        self.card = card
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, GameError> {
        let playerObj = ctx.player(actor)
        
        /// find card reference
        let cardObj: Card
        if let abilityIndex = playerObj.abilities.firstIndex(where: { $0.id == card }) {
            cardObj = playerObj.abilities[abilityIndex]
            
        } else {
            fatalError(.missingPlayerCard(card))
        }
        
        /// push child effects
        let playCtx = PlayContextImpl(actor: actor, playedCard: cardObj)
        let children = cardObj.onTrigger.withCtx(playCtx)
        
        return .success(EventOutputImpl(state: ctx, children: children))
    }
    
    public func isValid(_ ctx: Game) -> Result<Void, GameError> {
        let playerObj = ctx.player(actor)
        let cardObj = playerObj.card(card)
        let playCtx = PlayContextImpl(actor: actor, playedCard: cardObj)
        
        /// verify triggered effects not empty
        guard !cardObj.onTrigger.isEmpty else {
            return .failure(.cardHasNoTriggeredEffect)
        }
        
        /// verify all requirements
        for playReq in cardObj.triggers {
            if case let .failure(error) = playReq.match(ctx, playCtx: playCtx) {
                return .failure(error)
            }
        }
        
        return .success
    }
}
