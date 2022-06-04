//
//  Silent.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

import CardGameCore

/// prevents a card from taking effect on a player
public struct Silent: Effect, Equatable {
    
    let type: String
    
    let target: String
    
    public init(type: String, target: String = Args.playerActor) {
        self.type = type
        self.target = target
    }
    
    public func canResolve(ctx: State, actor: String) -> Result<Void, Error> {
        .success
    }
    
    public func resolve(ctx: State, cardRef: String) -> Result<State, Error> {
        guard Args.isPlayerResolved(target, ctx: ctx) else {
            return Args.resolvePlayer(target,
                                      copyWithTarget: { [self] in Silent(type: type, target: $0) },
                                      ctx: ctx,
                                      cardRef: cardRef)
        }
        
        var state = ctx
        
        let sequence = state.sequence(cardRef)
        guard let parentRef = sequence.parentRef else {
            fatalError(.sequenceParentRefNotFound(cardRef))
        }
        
        var parentSequence = state.sequence(parentRef)
        guard let indexToRemove = parentSequence.queue.firstIndex(where: { effect in
            guard let silentable = effect as? Silentable,
                  silentable.type == type,
                  silentable.target == target else {
                return false
            }
            return true
        }) else {
            return .failure(ErrorNoEffectToSilent(type: type))
        }
        
        parentSequence.queue.remove(at: indexToRemove)
        state.sequences[parentRef] = parentSequence
        state.lastEvent = self
        
        return .success(state)
    }
}
