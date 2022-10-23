//
//  Heal.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

public struct Heal: Effect {
    let value: Int
    let player: String
    
    public init(value: Int, player: String = Args.playerActor) {
        assert(value > 0)
        assert(!player.isEmpty)
        
        self.value = value
        self.player = player
    }
    
    public func resolve(in state: State, ctx: [String: String]) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(player, state: state) else {
            return Args.resolvePlayer(player,
                                      copyWithPlayer: { [self] in Heal(value: value, player: $0) },
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
