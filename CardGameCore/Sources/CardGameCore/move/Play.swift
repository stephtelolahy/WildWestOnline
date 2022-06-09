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
    private let card: String
    
    /// player
    private let actor: String
    
    public init(card: String, actor: String) {
        self.card = card
        self.actor = actor
    }
    
    public func dispatch(ctx: State) -> MoveResult {
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
        
        if ctx.isWaiting(self) {
            state.decisions.removeValue(forKey: actor)
        }
        
        let nodes = cardObj.onPlay.map { SequenceNode(effect: $0, actor: actor) }
        
        state.turnPlayed.append(cardObj.name)
        
        return .success(state, nodes)
    }
}
