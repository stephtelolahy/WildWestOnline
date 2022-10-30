//
//  State+Extension.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

public extension State {
    
    /// Get `non-null` `Player` with given identifier
    func player(_ id: String) -> Player {
        guard let result = players[id] else {
            fatalError(.missingPlayer(id))
        }
        return result
    }
    
    /// Check if a card can be played
    func canPlay(_ card: Card, actor: String) -> Result<Void, Error> {
        // verify all requirements
        for playReq in card.canPlay {
            if case let .failure(error) = playReq.verify(state: self, actor: actor, card: card) {
                return .failure(error)
            }
        }
        
        // verify first card effect
        guard var effect = card.onPlay.first else {
            return .failure(ErrorCardHasNoEffect())
        }
        
        effect.ctx = [.ACTOR: actor]
        if case let .failure(error) = verify(effect) {
            return .failure(error)
        }
        
        return .success
    }
    
    /// check if an effect will be resolved successfully
    func verify(_ effect: Effect) -> Result<Void, Error> {
        let result = effect.resolve(in: self)
        switch result {
        case let .failure(error):
            return .failure(error)
            
        case let .success(output):
            // update state
            let state = output.state ?? self
            
            // handle child effects: one of them must succeed
            if let effects = output.effects {
                return state.verify(effects)
            }
            
            // handle options: one of them must succeed
            if let options = output.options {
                let effects: [Effect] = options.map { ($0 as? Select)?.effects[0] ?? $0 }
                return state.verify(effects)
            }
            
            return .success
        }
    }
    
    /// Verify at least one effect succeed
    func verify(_ effects: [Effect]) -> Result<Void, Error> {
        let results = effects.map { verify($0) }
        let allFailed = results.allSatisfy({ !$0.isSuccess })
        if allFailed {
            return results[0]
        } else {
            return .success
        }
    }
}

public struct ErrorCardHasNoEffect: Error, Event, Equatable {
    public init() {}
}
