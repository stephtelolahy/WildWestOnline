//
//  Draw.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 05/06/2022.
//
import CardGameCore

/// draw a card from top deck
public struct Draw: Effect, Equatable {
    let player: String
    let times: String?
    
    @EquatableNoop
    public var ctx: [ContextKey: Any]
    
    public init(player: String = .PLAYER_ACTOR, times: String? = nil, ctx: [ContextKey: Any] = [:]) {
        assert(!player.isEmpty)
        
        self.player = player
        self.times = times
        self.ctx = ctx
    }
    
    public func resolve(in state: State) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(player, state: state) else {
            return Args.resolvePlayer(player,
                                      copy: { Draw(player: $0, times: times, ctx: ctx) },
                                      ctx: ctx,
                                      state: state)
        }
        
        if let times {
            return Args.resolveNumber(times, copy: { Draw(player: player, ctx: ctx) }, ctx: ctx, state: state)
        }
        
        var state = state
        var playerObj = state.player(player)
        let card = state.removeTopDeck()
        playerObj.hand.append(card)
        state.players[player] = playerObj
        
        return .success(EffectOutput(state: state))
    }
}
