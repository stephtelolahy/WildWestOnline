//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 01/06/2022.
//

/// play a card
/// Brown cards are put immediately in discard pile
/// Blue cards are put in play
public struct Play: Move, Equatable {
    
    let card: String
    
    let actor: String
    
    var target: String?
    
    // swiftlint:disable cyclomatic_complexity
    public func dispatch(ctx: State) -> Update {
        var state = ctx
        var actorObj = state.player(actor)
        
        let cardObj: Card
        
        if let handIndex = actorObj.hand.firstIndex(where: { $0.id == card }) {
            cardObj = actorObj.hand.remove(at: handIndex)
            // discard hand card immediately
            var discard = state.discard
            discard.append(cardObj)
            state.discard = discard
            state.players[actor] = actorObj
        } else if let figureIndex = actorObj.common.firstIndex(where: { $0.id == card }) {
            cardObj = actorObj.common[figureIndex]
        } else {
            fatalError(.playerCardNotFound(card))
        }
        
        // validate playReqs
        for playReq in cardObj.canPlay {
            if case let .failure(error) = playReq.verify(ctx: ctx, actor: actor, card: cardObj) {
                return Update(event: error)
            }
        }
        
        // validate target
        if let playTarget = cardObj.target {
            guard let target = target else {
                return Update(event: ErrorInvalidTarget(player: nil))
            }
            
            switch Args.resolveTarget(playTarget, ctx: ctx, actor: actor) {
            case let .success(options):
                guard options.contains(target) else {
                    return Update(event: ErrorInvalidTarget(player: target))
                }
                
            case let .failure(error):
                return Update(event: error)
            }
        }
        
        var sequence = Sequence(actor: actor, card: cardObj, selectedTarget: target, queue: cardObj.onPlay)
        
        if let decision = ctx.decision(waiting: self) {
            state.decisions.removeValue(forKey: actor)
            
            if let parentRef = decision.cardRef {
                sequence.parentRef = parentRef
            }
        }
        
        state.sequences[card] = sequence
        
        state.turnPlayed.append(cardObj.name)
        
        return Update(state: state, event: self)
    }
}
