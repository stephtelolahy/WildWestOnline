//
//  RulePlayImpl.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

extension Rules: RulePlay {
    
    public func canPlay(_ card: Card, actor: String, in ctx: Game) -> Result<Void, GameError> {
        // verify playing effects not empty
        guard !card.onPlay.isEmpty else {
            return .failure(.cardHasNoPlayingEffect)
        }
        
        // set playing data
        let playCtx = PlayContextImpl(actor: actor, playedCard: card)
        
        // verify all requirements
        for playReq in card.canPlay {
            if case let .failure(error) = playReq.match(ctx, playCtx: playCtx) {
                return .failure(error)
            }
        }
        
        // verify main effect succeed
        let node = card.onPlay[0].withCtx(playCtx)
        if case let .failure(error) = node.resolveUntilCompleted(ctx: ctx) {
            return .failure(error)
        }
        
        return .success
    }
}

private extension EffectNode {
    
    /// recursively resolve an effect until completed
    func resolveUntilCompleted(ctx: Game) -> Result<Void, GameError> {
        switch effect.resolve(ctx, playCtx: playCtx) {
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
            
            // handle options: one of them must succeed
            if let options = output.options {
                let children: [EffectNode] = options.map {
                    guard let choose = $0.effect as? Choose else {
                        return $0
                    }
                    
                    return choose.children[0]
                }
                let results = children.map { $0.resolveUntilCompleted(ctx: state) }
                if results.allSatisfy({ $0.isFailure }) {
                    return results[0]
                }
            }
            
            return .success
        }
    }
}
