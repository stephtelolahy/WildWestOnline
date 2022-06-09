//
//  Card+Extensions.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

public extension Card {
    
    /// Copy a card setting unique identifier
    func withId(_ id: String) -> Card {
        var copy = self
        copy.id = id
        return copy
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
            if case let .failure(error) = effect.verify(ctx: ctx, actor: actor, selectedArg: nil) {
                return .failure(error)
            }
        }
        
        return .success
    }
}

private extension Effect {
    
    /// check if an effect will be resolved successfully
    func verify(ctx: State, actor: String, selectedArg: String?) -> Result<Void, Error> {
        let result = resolve(ctx: ctx, actor: actor, selectedArg: selectedArg)
        switch result {
        case .success:
            return .success
            
        case let .failure(error):
            return .failure(error)
            
        case let .resolving(effects):
            let results = effects.map { $0.verify(ctx: ctx, actor: actor, selectedArg: nil) }
            if results.allSatisfy({ if case .failure = $0 { return true } else { return false } }) {
                return results[0]
            } else {
                return .success
            }
            
        case let .suspended(options):
            let moves = options.values.flatMap { $0 }
            let argValues: [String] = moves.compactMap { if let choose = $0 as? Choose { return choose.value } else { return nil } }
            let results = argValues.map { self.verify(ctx: ctx, actor: actor, selectedArg: $0) }
            if results.allSatisfy({ if case .failure = $0 { return true } else { return false } }) {
                return results[0]
            } else {
                return .success
            }
            
        case .remove:
            return .success
        }
    }
}
