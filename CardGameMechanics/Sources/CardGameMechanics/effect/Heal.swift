//
//  Heal.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

public struct Heal: Effect {
    
    let value: Int
    
    let target: String
    
    public init(value: Int, target: String = Args.playerActor) {
        self.value = value
        self.target = target
    }
    
    public func canResolve(ctx: State, actor: String) -> Result<Void, Error> {
        let result = Args.resolvePlayer(target, ctx: ctx, actor: actor)
        switch result {
        case let .success(data):
            switch data {
            case let .identified(pIds),
                let .selectable(pIds):
                if pIds.allSatisfy({ ctx.player($0).health == ctx.player($0).maxHealth }) {
                    return .failure(ErrorPlayerAlreadyMaxHealth(player: pIds[0]))
                } else {
                    return .success
                }
            }
            
        case let .failure(error):
            return .failure(error)
        }
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
