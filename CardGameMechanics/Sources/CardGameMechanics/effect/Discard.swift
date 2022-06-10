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
    
    public func resolve(ctx: State, actor: String, selectedArg: String?) -> EffectResult {
        guard Args.isPlayerResolved(target, ctx: ctx) else {
            return Args.resolvePlayer(target,
                                      copyWithPlayer: { [self] in Discard(card: card, target: $0, times: times) },
                                      ctx: ctx,
                                      actor: actor,
                                      selectedArg: selectedArg)
        }
        
        if let times = times {
            let value = Args.resolveNumber(times, actor: actor, ctx: ctx)
            guard value > 0 else {
                return .nothing
            }
            
            let effects = (0..<value).map { _ in Discard(card: card, target: target) }
            return .resolving(effects)
        }
        
        guard Args.isCardResolved(card, source: .player(target), ctx: ctx) else {
            return Args.resolveCard(card,
                                    copyWithCard: { Discard(card: $0, target: target) },
                                    source: .player(target),
                                    ctx: ctx,
                                    actor: actor,
                                    selectedArg: selectedArg)
        }
        
        var state = ctx
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
