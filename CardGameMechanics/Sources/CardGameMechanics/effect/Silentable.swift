//
//  Silentable.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

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
        
        let key = "\(target)-pass"
        guard !silentCards.isEmpty,
           sequence.selectedArgs[key] == nil  else {
            return nil
        }
        
        var actions: [Move] = silentCards.map { Play(card: $0.id, actor: target) }
        actions.append(Choose(value: "true", key: key, actor: target))
        
        var state = ctx
        state.decisions[target] = Decision(options: actions, cardRef: cardRef)
        sequence.queue.insert(self, at: 0)
        state.sequences[cardRef] = sequence
        
        return state
    }
}
