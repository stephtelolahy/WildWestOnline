//
//  Silent.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

import CardGameCore

public extension Args {
    
    /// do nothing about played card's effect
    static let choosePass = "Pass"
}


/// prevents an effect from being applied to a player
public struct Silent: Effect {
    
    let type: String
    
    let target: String
    
    public init(type: String, target: String = Args.playerActor) {
        self.type = type
        self.target = target
    }
    
    public func canResolve(ctx: State, actor: String) -> Result<Void, Error> {
        let result = Args.resolvePlayer(target, ctx: ctx, actor: actor)
        switch result {
        case let .success(data):
            switch data {
            case let .identified(pIds),
                let .selectable(pIds):
                let pId = pIds[0]
                guard ctx.sequences.values.contains(where: { sequence in
                    sequence.queue.contains(where: { effect in
                        guard let silentable = effect as? Silentable,
                              silentable.type == type,
                              silentable.target == pId else {
                            return false
                        }
                        return true
                    })
                }) else {
                    return .failure(ErrorNoEffectToSilent(type: type))
                }
                
                return .success
            }
            
        case let .failure(error):
            return .failure(error)
        }
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
            return .failure(ErrorNoEffectToSilent(type: type))
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

/// An effect that can be countered by target player
protocol Silentable {
    
    var target: String { get }
    
    var type: String? { get }
    
    /// Return a new state containing silent decision
    func prepareSilent(ctx: State, cardRef: String) -> State?
}

extension Silentable where Self: Effect {
    
    func prepareSilent(ctx: State, cardRef: String) -> State? {
        guard Args.isPlayerResolved(target, ctx: ctx),
              let effectType = type else {
            return nil
        }
        
        var sequence = ctx.sequence(cardRef)
        let targetObj = ctx.player(target)
        let silentCards = targetObj.hand.filter { $0.onPlay.contains { ($0 as? Silent)?.type == effectType } }
        
        guard !silentCards.isEmpty,
              sequence.selectedArgs[target] != Args.choosePass  else {
            sequence.selectedArgs.removeValue(forKey: target)
            return nil
        }
        
        var actions: [Move] = silentCards.map { Play(card: $0.id, actor: target) }
        actions.append(Choose(value: Args.choosePass, actor: target))
        
        var state = ctx
        state.decisions[target] = Decision(options: actions, cardRef: cardRef)
        sequence.queue.insert(self, at: 0)
        state.sequences[cardRef] = sequence
        
        return state
    }
}
