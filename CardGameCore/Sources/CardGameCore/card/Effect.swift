//
//  Effect.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 30/05/2022.
//

/// Effects have full power to update the game state
/// They can be resolved recursively to determine undetermined arguments
/// When dispatching an effect it can have 3 outcomes
/// - effect just prepared, triggering additional effects, don’t remove from queue
/// - effect partially resolved, replace with child effects
/// - effect resolved, remove from queue, you could render it
public protocol Effect: Event {
    func resolve(ctx: State, cardRef: String) -> State?
}
