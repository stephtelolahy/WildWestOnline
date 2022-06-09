//
//  Choose.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

/// select an argument during effect resolution
/// this action shoukld be a decision
public struct Choose: Move, Equatable {
    
    private let value: String
    
    private let actor: String
    
    public init(value: String, actor: String) {
        self.value = value
        self.actor = actor
    }
    
    public func dispatch(ctx: State) -> Result<State, Error> {
        guard ctx.isWaiting(self) else {
            return .failure(ErrorChooseOptionNotFound())
        }
        
        var state = ctx
        state.decisions.removeValue(forKey: actor)
        state.selectedArgs[actor] = value
        
        return .success(state)
    }
}

public struct ErrorChooseOptionNotFound: Error, Event {
}
