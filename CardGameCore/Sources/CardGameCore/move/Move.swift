//
//  Move.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

/// Moves are actions a player chooses to take on their turn while nothing is happening
/// such as playing a card, using your Hero Power and ending your turn
public protocol Move: Event {
    
    var actor: String { get }
    
    func dispatch(in state: State) -> Result<MoveOutput, Error>
}

public struct MoveOutput {
    let state: State
    var effects: [Effect]?
    var selectedArg: String?
    
    public init(state: State,
                effects: [Effect]? = nil,
                selectedArg: String? = nil) {
        self.state = state
        self.effects = effects
        self.selectedArg = selectedArg
    }
}
