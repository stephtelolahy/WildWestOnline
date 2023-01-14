//
//  RulePlayImpl.swift
//  
//
//  Created by Hugues Telolahy on 12/01/2023.
//

extension Rules: RulePlay {
 
    public func canPlay(_ card: Card, actor: String, in ctx: Game) -> Result<Void, GameError> {
        // add playing data
        var ctx = ctx
        ctx.queueActor = actor
        ctx.queueCard = card
        
        // verify all requirements
        for playReq in card.canPlay {
            if case let .failure(error) = playReq.match(ctx) {
                return .failure(error)
            }
        }
        
        // verify effects not empty
        guard let firstEffect = card.onPlay.first else {
            return .failure(.cardHasNoEffect)
        }
        
        // verify first effect
        if case let .failure(error) = firstEffect.resolveUntilCompleted(ctx: ctx) {
            return .failure(error)
        }
        
        return .success
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
            
            // handle options: one of them must succeed
            if let options = output.options {
                let children: [Effect] = options.map { ($0 as? Choose)?.effects[0] ?? $0 }
                let results = children.map { $0.resolveUntilCompleted(ctx: state) }
                if results.allSatisfy({ $0.isFailure }) {
                    return results[0]
                }
            }
            
            return .success
        }
    }
}
