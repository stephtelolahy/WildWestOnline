//
//  Play.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 01/06/2022.
//

/// play a card
/// Brown cards are put immediately in discard pile
/// Blue cards are put in play
public struct Play: Move, Equatable {
    
    /// played card
    let card: String
    
    /// player
    let actor: String
    
    public init(card: String, actor: String) {
        self.card = card
        self.actor = actor
    }
    
    public func dispatch(ctx: State) -> Result<State, Error> {
        var state = ctx
        var actorObj = ctx.player(actor)
        
        let cardObj: Card
        if let handIndex = actorObj.hand.firstIndex(where: { $0.id == card }) {
            cardObj = actorObj.hand.remove(at: handIndex)
            // discard played hand card immediately
            var discard = state.discard
            discard.append(cardObj)
            state.discard = discard
            state.players[actor] = actorObj
        } else if let figureIndex = actorObj.inner.firstIndex(where: { $0.id == card }) {
            cardObj = actorObj.inner[figureIndex]
        } else {
            fatalError(.playerCardNotFound(card))
        }
        
        // validate play
        if case let .failure(error) = cardObj.isPlayable(ctx, actor: actor) {
            return .failure(error)
        }
        
        var sequence = Sequence(actor: actor, card: cardObj, queue: cardObj.onPlay)
        
        if let decision = ctx.decision(waiting: self) {
            state.decisions.removeValue(forKey: actor)
            
            if let parentRef = decision.cardRef {
                sequence.parentRef = parentRef
            }
        }
        
        state.sequences[card] = sequence
        state.turnPlayed.append(cardObj.name)
        state.lastEvent = self
        return .success(state)
    }
}

extension Card {
    
    /// Check if a card can be played
    func isPlayable(_ ctx: State, actor: String) -> Result<Void, Error> {
        for playReq in canPlay {
            if case let .failure(error) = playReq.verify(ctx: ctx, actor: actor, card: self) {
                return .failure(error)
            }
        }
        
        for effect in onPlay {
            if case let .failure(error) = effect.canResolve(ctx: ctx, actor: actor) {
                return .failure(error)
            }
        }
        
        return .success
    }
}
