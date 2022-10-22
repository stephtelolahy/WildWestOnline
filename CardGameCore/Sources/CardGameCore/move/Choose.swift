//
//  Choose.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

/// select an argument during effect resolution
/// this action shoukld be a decision
public struct Choose: Move, Equatable {
    
    public let value: String
    
    public let actor: String
    
    public init(value: String, actor: String) {
        self.value = value
        self.actor = actor
    }
    
    public func dispatch(state: State) -> MoveResult {
        guard state.isWaiting(self) else {
            return .failure(ErrorChooseOptionNotFound())
        }
        
        var state = state
        state.removeDecisions(for: actor)
        
        return .success(state: state, effects: nil, selectedArg: value)
    }
}

public struct ErrorChooseOptionNotFound: Error, Event {
}
