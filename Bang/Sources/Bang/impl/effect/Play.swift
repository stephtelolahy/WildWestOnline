//
//  Play.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

/// Play a card
/// `Brown` cards are put immediately in discard pile
/// `Blue` cards are put in play
public struct Play: Effect, Equatable {
    private let actor: String
    private let card: String
    
    public init(actor: String, card: String) {
        self.actor = actor
        self.card = card
    }
    
    public func resolve(_ ctx: Game) -> Result<EffectOutput, GameError> {
        var ctx = ctx
        
        /// track actor as context data
        ctx.data[.actor] = actor
        
        var playerObj = ctx.player(actor)
        
        /// finc card reference
        let cardObj: Card
        if let handIndex = playerObj.hand.firstIndex(where: { $0.id == card }) {
            /// discard played card immediately
            cardObj = playerObj.hand.remove(at: handIndex)
            var discard = ctx.discard
            discard.append(cardObj)
            ctx.discard = discard
            ctx.players[actor] = playerObj
            
        } else if let abilityIndex = playerObj.abilities.firstIndex(where: { $0.id == card }) {
            cardObj = playerObj.abilities[abilityIndex]
            
        } else {
            fatalError(.missingPlayerCard(card))
        }
        
        /// verify all requirements
        for playReq in cardObj.canPlay {
            if case let .failure(error) = playReq.verify(ctx) {
                return .failure(error)
            }
        }
        
        /// verify effects not empty
        guard !cardObj.onPlay.isEmpty else {
            return .failure(.cardHasNoEffect)
        }
        
        /// verify first effect
        if case let .failure(error) = cardObj.onPlay[0].resolveUntilCompleted(ctx: ctx) {
            return .failure(error)
        }
        
        /// update turn played card
        ctx.played.append(cardObj.name)
        
        /// push child effects
        let children = cardObj.onPlay
        
        return .success(EffectOutputImpl(state: ctx, effects: children))
    }
}

private extension Effect {
    
    /// recursively resolve an effect until completed
    func resolveUntilCompleted(ctx: Game) -> Result<Void, GameError> {
        switch resolve(ctx) {
        case let .failure(error):
            return .failure(error)
            
        case let .success(output):
            // update state
            let state = output.state ?? ctx
            
            // handle child effects: one of them must succeed
            if let children = output.effects {
                let results = children.map { $0.resolveUntilCompleted(ctx: state) }
                if results.allSatisfy({ $0.isFailure }) {
                    return results[0]
                }
            }
            
            // handle decision options: one of them must succeed
            if let options = output.options {
                let children: [Effect] = options.map { ($0 as? Choose)?.effects[0] ?? $0 }
                let results = children.map { $0.resolveUntilCompleted(ctx: state) }
                if results.allSatisfy({ $0.isFailure }) {
                    return results[0]
                }
            }
            
            return .success(())
        }
    }
}

private extension Result {
    
    var isFailure: Bool {
        if case .failure = self {
            return true
        } else {
            return false
        }
    }
}
