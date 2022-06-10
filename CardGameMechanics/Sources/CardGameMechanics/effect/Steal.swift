//
//  Steal.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 06/06/2022.
//
import CardGameCore

/// draw some cards from other player
public struct Steal: Effect {
    
    private let actor: String
    
    private let card: String
    
    private let target: String
    
    public init(actor: String = Args.playerActor, card: String, target: String) {
        assert(!actor.isEmpty)
        assert(!card.isEmpty)
        assert(!target.isEmpty)
        
        self.actor = actor
        self.card = card
        self.target = target
    }
    
    public func resolve(ctx: State, actor: String, selectedArg: String?) -> EffectResult {
        guard Args.isPlayerResolved(actor, ctx: ctx) else {
            return Args.resolvePlayer(actor,
                                      copyWithPlayer: { [self] in Steal(actor: $0, card: card, target: target) },
                                      ctx: ctx,
                                      actor: actor,
                                      selectedArg: selectedArg)
        }
        
        guard Args.isPlayerResolved(target, ctx: ctx) else {
            return Args.resolvePlayer(target,
                                      copyWithPlayer: { [self] in Steal(actor: actor, card: card, target: $0) },
                                      ctx: ctx,
                                      actor: actor,
                                      selectedArg: selectedArg)
        }
        
        guard Args.isCardResolved(card, source: .player(target), ctx: ctx) else {
            return Args.resolveCard(card,
                                    copyWithCard: { Steal(actor: actor, card: $0, target: target) },
                                    source: .player(target),
                                    ctx: ctx,
                                    actor: actor,
                                    selectedArg: selectedArg)
        }
        
        var state = ctx
        var actorObj = state.player(actor)
        var targetObj = state.player(target)
        
        if let handIndex = targetObj.hand.firstIndex(where: { $0.id == card }) {
            let cardObj = targetObj.hand.remove(at: handIndex)
            actorObj.hand.append(cardObj)
        }
        
        if let inPlayIndex = targetObj.inPlay.firstIndex(where: { $0.id == card }) {
            let cardObj = targetObj.inPlay.remove(at: inPlayIndex)
            actorObj.hand.append(cardObj)
        }
        
        state.players[actor] = actorObj
        state.players[target] = targetObj
        
        return .success(state)
    }
}
