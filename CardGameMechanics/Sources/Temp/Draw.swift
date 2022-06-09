//
//  Draw.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//
import CardGameCore

/// draw X cards from top deck
public struct Draw: Effect {
    
    let value: Int
    
    let target: String
    
    public init(value: Int = 1, target: String = Args.playerActor) {
        self.value = value
        self.target = target
    }
    
    public func canResolve(ctx: State, actor: String) -> Result<Void, Error> {
        .success
    }
    
    public func resolve(ctx: State, cardRef: String) -> Result<State, Error> {
        guard Args.isPlayerResolved(target, ctx: ctx) else {
            return Args.resolvePlayer(target,
                                      copyWithTarget: { [self] in Draw(value: value, target: $0) },
                                      ctx: ctx,
                                      cardRef: cardRef)
        }
        
        /// split draw by 1
        if value > 1 {
            let events: [Draw] = (0..<value).map { _ in Draw(target: target) }
            var state = ctx
            var sequence = state.sequence(cardRef)
            sequence.queue.insert(contentsOf: events, at: 0)
            state.sequences[cardRef] = sequence
            return .success(state)
        }
        
        var state = ctx
        var player = state.player(target)
        let card = state.removeTopDeck()
        player.hand.append(card)
        state.players[target] = player
        state.lastEvent = self
        
        return .success(state)
    }
}
