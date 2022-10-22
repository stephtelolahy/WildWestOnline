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
    
    public func dispatch(in state: State) -> Result<MoveOutput, Error> {
        guard state.isWaiting(self) else {
            return .failure(ErrorChooseOptionNotFound())
        }
        
        var state = state
        state.removeDecisions(for: actor)
        
        return .success(MoveOutput(state: state, selectedArg: value))
    }
}

public struct ErrorChooseOptionNotFound: Error, Event {
}
