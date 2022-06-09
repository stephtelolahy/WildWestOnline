//
//  Heal.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

public struct Heal: Effect {
    
    private let value: Int
    
    private let target: String
    
    public init(value: Int, target: String = Args.playerActor) {
        self.value = value
        self.target = target
    }
    
    public func resolve(ctx: State, actor: String) -> EffectResult {
        guard Args.isPlayerResolved(target, ctx: ctx) else {
            return Args.resolvePlayer(target,
                                      copyWithPlayer: { [self] in Heal(value: value, target: $0) },
                                      ctx: ctx,
                                      actor: actor)
        }
        
        var targetObj = ctx.player(target)
        guard targetObj.health < targetObj.maxHealth else {
            return .failure(ErrorPlayerAlreadyMaxHealth(player: target))
        }
        
        let newHealth = min(targetObj.health + value, targetObj.maxHealth)
        targetObj.health = newHealth
        var state = ctx
        state.players[target] = targetObj
        
        return .success(state)
    }
}
