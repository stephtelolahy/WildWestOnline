//
//  Discard.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//
import CardGameCore

/// discard player's card to discard pile
public struct Discard: Effect {
    
    private let card: String
    
    private let target: String
    
    private let times: String?
    
    public init(card: String, target: String = Args.playerActor, times: String? = nil) {
        assert(!card.isEmpty)
        assert(!target.isEmpty)
        
        self.card = card
        self.target = target
        self.times = times
    }
    
    public func resolve(state: State, ctx: PlayContext) -> EffectResult {
        guard Args.isPlayerResolved(target, state: state) else {
            return Args.resolvePlayer(target,
                                      copyWithPlayer: { [self] in Discard(card: card, target: $0, times: times) },
                                      state: state,
                                      ctx: ctx)
        }
        
        if let times = times {
            return Args.resolveNumber(times, copy: { Discard(card: card, target: target) }, actor: ctx.actor, state: state)
        }
        
        guard Args.isCardResolved(card, source: .player(target), state: state) else {
            return Args.resolveCard(card,
                                    copyWithCard: { Discard(card: $0, target: target) },
                                    chooser: ctx.actor,
                                    source: .player(target),
                                    state: state,
                                    ctx: ctx)
        }
        
        var state = state
        var targetObj = state.player(target)
        
        if let handIndex = targetObj.hand.firstIndex(where: { $0.id == card }) {
            let cardObj = targetObj.hand.remove(at: handIndex)
            state.discard.append(cardObj)
        }
        
        if let inPlayIndex = targetObj.inPlay.firstIndex(where: { $0.id == card }) {
            let cardObj = targetObj.inPlay.remove(at: inPlayIndex)
            state.discard.append(cardObj)
        }
        
        state.players[target] = targetObj
        
        return .success(state)
    }
}
