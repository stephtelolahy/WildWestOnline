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
        assert(value > 0)
        assert(!target.isEmpty)
        
        self.value = value
        self.target = target
    }
    
    public func resolve(in state: State, ctx: [String: String]) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(target, state: state) else {
            return Args.resolvePlayer(target,
                                      copyWithPlayer: { [self] in Heal(value: value, target: $0) },
                                      state: state,
                                      ctx: ctx)
        }
        
        var targetObj = state.player(target)
        guard targetObj.health < targetObj.maxHealth else {
            return .failure(ErrorPlayerAlreadyMaxHealth(player: target))
        }
        
        let newHealth = min(targetObj.health + value, targetObj.maxHealth)
        targetObj.health = newHealth
        var state = state
        state.players[target] = targetObj
        
        return .success(EffectOutput(state: state))
    }
}
