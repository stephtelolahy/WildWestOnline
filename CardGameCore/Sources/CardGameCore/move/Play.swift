//
//  Play.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 01/06/2022.
//
// swiftlint:disable identifier_name

/// play a card
/// Brown cards are put immediately in discard pile
/// Blue cards are put in play
public struct Play: Move, Equatable {
    let card: String
    public let actor: String
    
    @EquatableNoop
    public var ctx: [String: Any]
    
    public init(card: String, actor: String, ctx: [String: Any] = [:]) {
        self.card = card
        self.actor = actor
        self.ctx = ctx
    }
    
    public func resolve(in state: State) -> Result<EffectOutput, Error> {
        var state = state
        var actorObj = state.player(actor)
        
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
            fatalError(.missingPlayerCard(card))
        }
        
        // verify card playable
        if case let .failure(error) = state.canPlay(cardObj, actor: actor) {
            return .failure(error)
        }
        
        state.played.append(cardObj.name)
        
        let effects = cardObj.onPlay.map {
            var copy = $0
            copy.ctx = [.CTX_ACTOR: actor]
            return copy
        }
        
        return .success(EffectOutput(state: state, effects: effects))
    }
}

public extension String {
    
    /// the player who played the card owning the effect
    static let CTX_ACTOR = "ACTOR"
}
