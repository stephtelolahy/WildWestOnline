//
//  Steal.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 06/06/2022.
//
import CardGameCore

/// draw some cards from other player
public struct Steal: Effect, Equatable {
    let player: String
    let card: String
    let target: String
    
    @EquatableNoop
    public var ctx: [ContextKey: Any]
    
    public init(player: String, card: String, target: String, ctx: [ContextKey: Any] = [:]) {
        assert(!player.isEmpty)
        assert(!card.isEmpty)
        assert(!target.isEmpty)
        
        self.player = player
        self.card = card
        self.target = target
        self.ctx = ctx
    }
    
    public func resolve(in state: State) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(player, state: state) else {
            return Args.resolvePlayer(player,
                                      copy: { Steal(player: $0, card: card, target: target, ctx: ctx) },
                                      ctx: ctx,
                                      state: state)
        }
        
        guard Args.isPlayerResolved(target, state: state) else {
            return Args.resolvePlayer(target,
                                      copy: { Steal(player: player, card: card, target: $0, ctx: ctx) },
                                      ctx: ctx,
                                      state: state)
        }
        
        guard Args.isCardResolved(card, source: .player(target), state: state) else {
            return Args.resolveCard(card,
                                    copy: { Steal(player: player, card: $0, target: target, ctx: ctx) },
                                    chooser: player,
                                    source: .player(target),
                                    ctx: ctx,
                                    state: state)
        }
        
        var state = state
        var playerObj = state.player(player)
        var targetObj = state.player(target)
        
        if let handIndex = targetObj.hand.firstIndex(where: { $0.id == card }) {
            let cardObj = targetObj.hand.remove(at: handIndex)
            playerObj.hand.append(cardObj)
        }
        
        if let inPlayIndex = targetObj.inPlay.firstIndex(where: { $0.id == card }) {
            let cardObj = targetObj.inPlay.remove(at: inPlayIndex)
            playerObj.hand.append(cardObj)
        }
        
        state.players[player] = playerObj
        state.players[target] = targetObj
        
        return .success(EffectOutput(state: state))
    }
}
