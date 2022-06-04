//
//  Effect.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 30/05/2022.
//

/// Effects have full power to update the game state
public protocol Effect: Event {
    
    /// Resolving effect recursively to determine undetermined arguments
    /// When dispatching an effect it can have several outcomes:
    /// - effect just prepared, triggering additional effects, don’t remove from queue
    /// - effect partially resolved, replace with child effects
    /// - effect resolved, remove from queue, you could render it
    /// - effect failed, remove from queue, you could display error message
    func resolve(ctx: State, cardRef: String) -> Result<State, Error>
    
    /// Determines whever an effect resolution will succeed
    /// Use this condition to determine if a card is playable
    func canResolve(ctx: State, actor: String) -> Result<Void, Error>
}
