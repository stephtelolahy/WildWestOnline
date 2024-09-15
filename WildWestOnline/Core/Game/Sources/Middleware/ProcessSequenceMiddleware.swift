//
//  ProcessSequenceMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//

import Foundation
import Redux

extension Middlewares {
    static func processSequence() -> Middleware<GameState> {
        { state, action in
            guard let action = action as? GameAction else {
                return nil
            }

            switch action {
            case .endGame,
                 .chooseOne,
                 .activate:
                return nil

            default:
                guard let nextAction = state.sequence.queue.first else {
                    return nil
                }

                // emit effect after delay if current action is renderable
                if action.isRenderable {
                    let milliToNanoSeconds = 1_000_000
                    let waitDelay = state.waitDelayMilliseconds
                    try? await Task.sleep(nanoseconds: UInt64(waitDelay * milliToNanoSeconds))
                }

                return nextAction
            }
        }
    }
}
