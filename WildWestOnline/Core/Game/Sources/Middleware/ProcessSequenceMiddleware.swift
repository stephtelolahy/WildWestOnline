//
//  ProcessSequenceMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//

import Foundation
import Combine
import Redux

extension Middlewares {
    static func processSequence() -> Middleware<GameState> {
        { state, action in
            guard let action = action as? GameAction else {
                return Empty().eraseToAnyPublisher()
            }

            switch action {
            case .endGame,
                 .chooseOne,
                 .activate:
                return Empty().eraseToAnyPublisher()

            default:
                guard let nextAction = state.queue.first else {
                    return Empty().eraseToAnyPublisher()
                }

                // emit effect after delay if current action is renderable
                if action.isRenderable {
                    return Just(nextAction)
                        .delay(for: .seconds(state.waitDelaySeconds), scheduler: RunLoop.main)
                        .eraseToAnyPublisher()
                }

                return Just(nextAction).eraseToAnyPublisher()
            }
        }
    }
}
