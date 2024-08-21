// swiftlint:disable:this file_name
//
//  ProcessSequenceMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//

import Foundation
import Redux

extension Middlewares {
    static func processSequence() -> Middleware<GameState, GameAction> {
        { state, action in
            switch action {
            case .endGame,
                    .chooseOne,
                    .activate:
                return nil

            default:
                guard let nextAction = state.sequence.queue.first else {
                    return nil
                }

                if action.isRenderable {
                    let milliToNanoSeconds = 1_000_000
                    let waitDelay = state.config.waitDelayMilliseconds
                    try? await Task.sleep(nanoseconds: UInt64(waitDelay * milliToNanoSeconds))
                }

                return nextAction
            }
        }
    }
}
