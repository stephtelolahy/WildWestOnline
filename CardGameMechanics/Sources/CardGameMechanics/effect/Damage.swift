//
//  Damage.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

/// Deals damage to a character, attempting to reduce its Health by the stated amount
///
public struct Damage: Effect, Silentable {
    let value: Int
    let player: String
    let type: String?
    
    public init(value: Int, player: String = .PLAYER_ACTOR, type: String? = nil) {
        assert(value > 0)
        assert(!player.isEmpty)
        
        self.value = value
        self.player = player
        self.type = type
    }
    
    public func resolve(in state: State, ctx: [EffectKey: String]) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(player, state: state) else {
            return Args.resolvePlayer(player,
                                      copyWithPlayer: { [self] in Damage(value: value, player: $0, type: type) },
                                      ctx: ctx,
                                      state: state)
        }
        
        if let options = counterMoves(state: state, ctx: ctx) {
            return .success(EffectOutput(decisions: options))
        }
        
        var state = state
        var playerObj = state.player(player)
        playerObj.health -= value
        state.players[player] = playerObj
        
        return .success(EffectOutput(state: state))
    }
}
