//
//  Play.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Move
/// Play a card
public struct Play: Effect, Equatable {
    private let actor: String
    private let card: String
    private let target: String?
    
    public init(actor: String, card: String, target: String? = nil) {
        self.actor = actor
        self.card = card
        self.target = target
    }
    
    public func resolve(_ ctx: Game, playCtx: PlayContext) -> Result<EffectOutput, GameError> {
        var ctx = ctx
        var playerObj = ctx.player(actor)
        
        /// find card reference
        let cardObj: Card
        if let handIndex = playerObj.hand.firstIndex(where: { $0.id == card }) {
            /// discard played card immediately
            cardObj = playerObj.hand.remove(at: handIndex)
            var discard = ctx.discard
            discard.append(cardObj)
            ctx.discard = discard
            ctx.players[actor] = playerObj
            
        } else if let abilityIndex = playerObj.abilities.firstIndex(where: { $0.id == card }) {
            cardObj = playerObj.abilities[abilityIndex]
            
        } else {
            fatalError(.missingPlayerCard(card))
        }
        
        /// set playing data
        let playCtx = PlayContextImpl(actor: actor, playedCard: cardObj, target: target)
        
        /// resolve playTarget if any
        if let playTarget = cardObj.playTarget,
           target == nil {
            return resolve(playTarget, ctx: ctx, playCtx: playCtx) {
                Self(actor: actor, card: card, target: $0)
            }
        }
        
        /// verify can play
        if case let .failure(error) = Rules.main.canPlay(playCtx, in: ctx) {
            return .failure(error)
        }
        
        /// set playing data
        ctx.played.append(cardObj.name)
        
        /// push child effects
        let children = cardObj.onPlay.withCtx(playCtx)
        
        return .success(EffectOutputImpl(state: ctx, effects: children))
    }
}
