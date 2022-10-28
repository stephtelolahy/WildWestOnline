//
//  Discard.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//
import CardGameCore

/// discard player's card to discard pile
public struct Discard: Effect, Equatable {
    let card: String
    let player: String
    let times: String?
    
    @EquatableNoop
    public var ctx: [ContextKey: Any]
    
    public init(card: String, player: String = .PLAYER_ACTOR, times: String? = nil, ctx: [ContextKey: Any] = [:]) {
        assert(!card.isEmpty)
        assert(!player.isEmpty)
        
        self.card = card
        self.player = player
        self.times = times
        self.ctx = ctx
    }
    
    public func resolve(in state: State) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(player, state: state) else {
            return Args.resolvePlayer(player,
                                      copy: { Discard(card: card, player: $0, times: times, ctx: ctx) },
                                      ctx: ctx,
                                      state: state)
        }
        
        if let times {
            return Args.resolveNumber(times, copy: { Discard(card: card, player: player, ctx: ctx) }, ctx: ctx, state: state)
        }
        
        guard Args.isCardResolved(card, source: .player(player), state: state) else {
            return Args.resolveCard(card,
                                    copy: { Discard(card: $0, player: player, ctx: ctx) },
                                    chooser: ctx.actor,
                                    source: .player(player),
                                    ctx: ctx,
                                    state: state)
        }
        
        var state = state
        var playerObj = state.player(player)
        
        if let handIndex = playerObj.hand.firstIndex(where: { $0.id == card }) {
            let cardObj = playerObj.hand.remove(at: handIndex)
            state.discard.append(cardObj)
        }
        
        if let inPlayIndex = playerObj.inPlay.firstIndex(where: { $0.id == card }) {
            let cardObj = playerObj.inPlay.remove(at: inPlayIndex)
            state.discard.append(cardObj)
        }
        
        state.players[player] = playerObj
        
        return .success(EffectOutput(state: state))
    }
}
