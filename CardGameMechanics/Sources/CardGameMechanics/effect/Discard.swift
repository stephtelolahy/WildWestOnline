//
//  Discard.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//
import CardGameCore

/// discard player's card to discard pile
public struct Discard: Effect {
    
    let card: String
    
    let target: String
    
    let times: String?
    
    public init(card: String, target: String = Args.playerActor, times: String? = nil) {
        self.card = card
        self.target = target
        self.times = times
    }
    
    public func canResolve(ctx: State, actor: String) -> Result<Void, Error> {
        .success
    }
    
    public func resolve(ctx: State, cardRef: String) -> Result<State, Error> {
        if let times = times {
            let value = Args.resolveNumber(times, ctx: ctx, cardRef: cardRef)
            var state = ctx
            let copy = (0..<value).map { _ in Discard(card: card, target: target) }
            var sequence = ctx.sequence(cardRef)
            sequence.queue.insert(contentsOf: copy, at: 0)
            state.sequences[cardRef] = sequence
            
            return .success(state)
        }
        
        guard Args.isPlayerResolved(target, ctx: ctx) else {
            return Args.resolvePlayer(target,
                                      copyWithTarget: { [self] in Discard(card: card, target: $0) },
                                      ctx: ctx,
                                      cardRef: cardRef)
        }
        
        guard Args.isCardResolved(card, source: .player(target), ctx: ctx) else {
            return Args.resolveCard(card,
                                    copyWithCard: { Discard(card: $0, target: target) },
                                    actor: ctx.sequence(cardRef).actor,
                                    source: .player(target),
                                    ctx: ctx,
                                    cardRef: cardRef)
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
        state.lastEvent = self
        
        return .success(state)
    }
}
