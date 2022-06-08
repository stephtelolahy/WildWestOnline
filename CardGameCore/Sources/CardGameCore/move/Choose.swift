//
//  Choose.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

/// select an argument during effect resolution
/// this action shoukld be a decision
public struct Choose: Move, Equatable {
    
    let value: String
    
    let key: String
    
    let actor: String
    
    public init(value: String, key: String, actor: String) {
        self.value = value
        self.key = key
        self.actor = actor
    }
    
    public func dispatch(ctx: State) -> Result<State, Error> {
        guard let decision = ctx.decision(waiting: self),
              let cardRef = decision.cardRef else {
            fatalError(.chooseOptionNotFound)
        }
        
        var state = ctx
        var sequence = state.sequence(cardRef)
        state.decisions.removeValue(forKey: actor)
        sequence.selectedArgs[key] = value
        state.sequences[cardRef] = sequence
        state.lastEvent = self
        
        return .success(state)
    }
}
