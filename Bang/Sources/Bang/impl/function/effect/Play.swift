//
//  Play.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Move
/// Play a card
/// `Brown` cards are put immediately in discard pile
/// `Blue` cards are put in play
public struct Play: Effect, Equatable {
    private let actor: String
    private let card: String
    
    public init(actor: String, card: String) {
        self.actor = actor
        self.card = card
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
        
        /// verify can play
        if case let .failure(error) = Rules.main.canPlay(cardObj, actor: actor, in: ctx) {
            return .failure(error)
        }
        
        /// set playing data
        ctx.played.append(cardObj.name)
        
        /// push child effects
        let playCtx = PlayContextImpl(actor: actor, playedCard: cardObj)
        let children = cardObj.onPlay.withCtx(playCtx)
        
        return .success(EffectOutputImpl(state: ctx, effects: children))
    }
}
