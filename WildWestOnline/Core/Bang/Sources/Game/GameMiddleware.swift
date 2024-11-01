//
//  GameMiddleware.swift
//  Bang
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import Redux
import Combine

/// Game loop features
public extension Middlewares {
    static func updateGame() -> Middleware<GameState> {
        { state, _ in
            guard state.queue.isNotEmpty else {
                return Empty().eraseToAnyPublisher()
            }

            let nextAction = state.queue[0]

            // handle choice
            if let selector = nextAction.payload.selectors.first,
               case .chooseOne(let chooseOneDetails) = selector,
               chooseOneDetails.options.isNotEmpty,
               chooseOneDetails.selection == nil {
                let selection = chooseOneDetails.options[0]
                let chooseAction = GameAction.choose(selection)
                return Just(chooseAction).eraseToAnyPublisher()
            }

            return Just(nextAction).eraseToAnyPublisher()
        }
    }
}
