//
//  Damage.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

/// deals damage to a character, attempting to reduce its Health by the stated amount
public struct Damage: Effect, Silentable, Equatable {
    
    let value: Int
    
    let target: String
    
    let type: String?
    
    public init(value: Int, target: String = Args.playerActor, type: String? = nil) {
        self.value = value
        self.target = target
        self.type = type
    }
    
    public func canResolve(ctx: State, actor: String) -> Result<Void, Error> {
        if case let .failure(error) = Args.resolvePlayer(target, ctx: ctx, actor: actor) {
            return .failure(error)
        }
        
        return .success
    }
    
    public func resolve(ctx: State, cardRef: String) -> Result<State, Error> {
        if let silentDecisionState = prepareSilent(ctx: ctx, cardRef: cardRef) {
            return .success(silentDecisionState)
        }
        
        guard Args.isPlayerResolved(target, ctx: ctx) else {
            return Args.resolvePlayer(target,
                                      copyWithTarget: { [self] in Damage(value: value, target: $0, type: type) },
                                      ctx: ctx,
                                      cardRef: cardRef)
        }
        
        var state = ctx
        var player = state.player(target)
        player.health -= value
        state.players[target] = player
        state.lastEvent = self
        
        return .success(state)
    }
}
