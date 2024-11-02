//
//  GameMiddleware.swift
//  Bang
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import Combine

/// Game loop features
public extension Middlewares {
    static func updateGame(choiceHandler: GameChoiceHandler) -> Middleware<GameState> {
        { state, _ in
            guard state.queue.isNotEmpty else {
                return nil
            }

            let nextAction = state.queue[0]

            // handle choice
            if let selector = nextAction.payload.selectors.first,
               case .chooseOne(let chooseOneDetails) = selector,
               chooseOneDetails.options.isNotEmpty,
               chooseOneDetails.selection == nil {
                let selection = choiceHandler.bestMove(options: chooseOneDetails.options.map(\.label))
                let chooseAction = GameAction.choose(selection)
                return Just(chooseAction).eraseToAnyPublisher()
            }

            return Just(nextAction).eraseToAnyPublisher()
        }
    }
}

public protocol GameChoiceHandler {
    func bestMove(options: [String]) -> String
}
