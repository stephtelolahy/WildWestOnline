//
//  Damage.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

/// deals damage to a character, attempting to reduce its Health by the stated amount
public struct Damage: Effect/*, Silentable*/ {
    
    let value: Int
    
    let target: String
    
    let type: String?
    
    public init(value: Int, target: String = Args.playerActor, type: String? = nil) {
        self.value = value
        self.target = target
        self.type = type
    }
    
    public func resolve(ctx: State, actor: String, selectedArg: String?) -> EffectResult {
        /*
        if let silentDecisionState = resolveSilent(ctx: ctx, cardRef: cardRef) {
            return .success(silentDecisionState)
        }
        */
        guard Args.isPlayerResolved(target, ctx: ctx) else {
            return Args.resolvePlayer(target,
                                      copyWithPlayer: { [self] in Damage(value: value, target: $0, type: type) },
                                      ctx: ctx,
                                      actor: actor,
                                      selectedArg: selectedArg)
        }
        
        var state = ctx
        var player = state.player(target)
        player.health -= value
        state.players[target] = player
        
        return .success(state)
    }
}
