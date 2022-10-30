//
//  Heal.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

public struct Heal: Effect, Equatable {
    let value: Int
    let player: String
    
    @EquatableNoop
    public var ctx: [String: Any]
    
    public init(value: Int, player: String = .PLAYER_ACTOR, ctx: [String: Any] = [:]) {
        assert(value > 0)
        assert(!player.isEmpty)
        
        self.value = value
        self.player = player
        self.ctx = ctx
    }
    
    public func resolve(in state: State) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(player, state: state) else {
            return Args.resolvePlayer(player,
                                      copy: { Heal(value: value, player: $0, ctx: ctx) },
                                      ctx: ctx,
                                      state: state)
        }
        
        var playerObj = state.player(player)
        guard playerObj.health < playerObj.maxHealth else {
            return .failure(ErrorPlayerAlreadyMaxHealth(player: player))
        }
        
        let newHealth = min(playerObj.health + value, playerObj.maxHealth)
        playerObj.health = newHealth
        var state = state
        state.players[player] = playerObj
        
        return .success(EffectOutput(state: state))
    }
}
