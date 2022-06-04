//
//  Heal.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

public struct Heal: Effect {
    
    let value: Int
    var target: String
    
    public init(value: Int, target: String = Args.playerActor) {
        self.value = value
        self.target = target
    }
    
    public func resolve(ctx: State, cardRef: String) -> Result<State, Error> {
        guard Args.isPlayerResolved(target, ctx: ctx) else {
            return Args.resolvePlayer(target,
                                      copyWithTarget: { [self] in Heal(value: value, target: $0) },
                                      ctx: ctx,
                                      cardRef: cardRef)
        }
        
        var state = ctx
        var player = state.player(target)
        let currHealth = player.health
        
        guard currHealth < player.maxHealth else {
            return .failure(ErrorPlayerAlreadyMaxHealth(player: target))
        }
        
        let newHealth = min(currHealth + value, player.maxHealth)
        player.health = newHealth
        state.players[target] = player
        state.lastEvent = self
        
        return .success(state)
    }
}
