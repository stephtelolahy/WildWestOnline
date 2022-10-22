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
    
    public init(actor: String, card: String, target: String) {
        assert(!actor.isEmpty)
        assert(!card.isEmpty)
        assert(!target.isEmpty)
        
        self.actor = actor
        self.card = card
        self.target = target
    }
    
    public func resolve(in state: State, ctx: PlayContext) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(actor, state: state) else {
            return Args.resolvePlayer(actor,
                                      copyWithPlayer: { [self] in Steal(actor: $0, card: card, target: target) },
                                      state: state,
                                      ctx: ctx)
        }
        
        guard Args.isPlayerResolved(target, state: state) else {
            return Args.resolvePlayer(target,
                                      copyWithPlayer: { [self] in Steal(actor: actor, card: card, target: $0) },
                                      state: state,
                                      ctx: ctx)
        }
        
        guard Args.isCardResolved(card, source: .player(target), state: state) else {
            return Args.resolveCard(card,
                                    copyWithCard: { Steal(actor: actor, card: $0, target: target) },
                                    chooser: ctx.actor,
                                    source: .player(target),
                                    state: state,
                                    ctx: ctx)
        }
        
        var state = state
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
        
        return .success(EffectOutput(state: state))
    }
}
