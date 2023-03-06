//
//  Trigger.swift
//  
//
//  Created by Hugues Telolahy on 13/01/2023.
//
import GameUtils

/// Trigger a card after an event occured
public struct Trigger: Event, Equatable {
    public let actor: String
    private let card: String
    @EquatableIgnore public var eventCtx: EventContext = EventContextImpl()
    
    public init(actor: String, card: String) {
        self.actor = actor
        self.card = card
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, Error> {
        let playerObj = ctx.player(actor)
        let cardObj = playerObj.card(card)
        
        /// push child effects
        let eventCtx = EventContextImpl(actor: actor, card: cardObj)
        let children = cardObj.onTrigger?.withCtx(eventCtx)
        
        return .success(EventOutputImpl(state: ctx, children: children))
    }
    
    public func isValid(_ ctx: Game) -> Result<Void, Error> {
        let playerObj = ctx.player(actor)
        let cardObj = playerObj.card(card)
        let eventCtx = EventContextImpl(actor: actor, card: cardObj)
        
        /// verify triggered effects not empty
        guard cardObj.onTrigger != nil else {
            return .failure(EngineError.cardHasNoTriggeredEffect)
        }
        
        /// verify all requirements
        if let playReqs = cardObj.triggers {
            for playReq in playReqs {
                if case let .failure(error) = playReq.match(ctx, eventCtx: eventCtx) {
                    return .failure(error)
                }
            }
        }
        
        return .success
    }
}
