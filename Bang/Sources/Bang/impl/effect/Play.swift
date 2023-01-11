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
        
        var playerObj = ctx.player(actor)
        guard let handIndex = playerObj.hand.firstIndex(where: { $0.id == card }) else {
            fatalError(.missingPlayerCard(card))
        }
        
        var ctx = ctx
        
        /// keep actor as context data
        ctx.data[.actor] = actor
        
        /// discard played card
        let cardObj = playerObj.hand.remove(at: handIndex)
        var discard = ctx.discard
        discard.append(cardObj)
        ctx.discard = discard
        ctx.players[actor] = playerObj
        
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
        if case let .failure(error) = resolveUntilCompleted(cardObj.onPlay[0], ctx: ctx) {
            return .failure(error)
        }
        
        /// update turn played card
        ctx.played.append(cardObj.name)
        
        /// push child effects
        let children = cardObj.onPlay
        
        return .success(EffectOutputImpl(state: ctx, effects: children))
    }
    
    /// recursively resolve an effect until completed
    private func resolveUntilCompleted(_ effect: Effect, ctx: Game) -> Result<Void, GameError> {
        let result = effect.resolve(ctx)
        switch result {
        case let .failure(error):
            return .failure(error)
            
        case let .success(output):
            // handle child effects: one of them must succeed
            if let children = output.effects {
                let state = output.state ?? ctx
                let results = children.map { resolveUntilCompleted($0, ctx: state) }
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
