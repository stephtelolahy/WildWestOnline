//
//  Damage.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

/// Deals damage to a character, attempting to reduce its Health by the stated amount
///
public struct Damage: Effect, Silentable, Equatable {
    
    let value: Int
    
    let player: String
    
    let type: String?
    
    @EquatableNoop
    public var ctx: [ContextKey: Any]
    
    public init(value: Int, player: String = .PLAYER_ACTOR, type: String? = nil, ctx: [ContextKey: Any] = [:]) {
        assert(value > 0)
        assert(!player.isEmpty)
        
        self.value = value
        self.player = player
        self.type = type
        self.ctx = ctx
    }
    
    public func resolve(in state: State) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(player, state: state) else {
            return Args.resolvePlayer(player,
                                      copy: { Damage(value: value, player: $0, type: type, ctx: ctx) },
                                      ctx: ctx,
                                      state: state)
        }
        
        if let options = reactionMoves(in: state) {
            return .success(EffectOutput(options: options))
        }
        
        var state = state
        var playerObj = state.player(player)
        playerObj.health -= value
        state.players[player] = playerObj
        
        return .success(EffectOutput(state: state))
    }
}
