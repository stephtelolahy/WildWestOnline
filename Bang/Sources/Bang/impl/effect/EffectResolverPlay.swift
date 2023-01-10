//
//  EffectResolverPlay.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

struct EffectResolverPlay: EffectResolver {
    
    let verifier: PlayReqVerifier
    let mainResolver: EffectResolver
    
    func resolve(_ effect: Effect, ctx: Game) -> Result<EffectOutput, GameError> {
        guard case let .play(actor, card) = effect else {
            fatalError("unexpected effect type \(effect)")
        }
        
        guard var playerObj = ctx.players[actor] else {
            fatalError("player not found \(actor)")
        }
        
        guard let handIndex = playerObj.hand.firstIndex(where: { $0.id == card }) else {
            fatalError("card not found \(card)")
        }
        
        var state = ctx
        
        /// discard played card
        let cardObj = playerObj.hand.remove(at: handIndex)
        var discard = state.discard
        discard.append(cardObj)
        state.discard = discard
        state.players[actor] = playerObj
        
        /// verify all requirements
        for playReq in cardObj.canPlay {
            if case let .failure(error) = verifier.verify(playReq, ctx: ctx) {
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
        state.played.append(cardObj.name)
        
        /// push child effects
        let children = cardObj.onPlay
        
        return .success(EffectOutputImpl(state: state, effects: children))
    }
    
    /// recursively resolve an effect until completed
    private func resolveUntilCompleted(_ effect: Effect, ctx: Game) -> Result<Void, GameError> {
        let result = mainResolver.resolve(effect, ctx: ctx)
        switch result {
        case let .failure(error):
            return .failure(error)
            
        case let .success(output):
            // handle child effects: one of them must succeed
            if let children = output.effects {
                let state = output.state ?? ctx
                let results = children.map { resolveUntilCompleted($0, ctx: state) }
                let allFailed = results.allSatisfy({ $0.isError })
                if allFailed {
                    return results[0]
                }
            }
            
            return .success(())
        }
    }
}

private extension Result {
    
    var isSuccess: Bool {
        if case .success = self {
            return true
        } else {
            return false
        }
    }
    
    var isError: Bool {
        !isSuccess
    }
}
