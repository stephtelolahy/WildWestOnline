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
    
    let actor: String
    
    public init(value: String, actor: String) {
        self.value = value
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
        sequence.selectedArgs[actor] = value
        state.sequences[cardRef] = sequence
        
        return .success(state)
    }
}
