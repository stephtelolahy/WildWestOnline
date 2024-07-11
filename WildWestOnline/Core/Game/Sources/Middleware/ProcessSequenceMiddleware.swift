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
    static func processSequence() -> Middleware<GameState> {
        { state, action in
            guard let action = action as? GameAction else {
                return nil
            }

            switch action {
            case .setGameOver,
                    .chooseOne,
                    .activate:
                return nil

            default:
                guard let nextAction = state.sequence.queue.first else {
                    return nil
                }

                let waitDelay = if nextAction.isRenderable {
                    state.waitDelayMilliseconds
                } else {
                    0
                }

                let milliToNanoSeconds = 1_000_000
                try? await Task.sleep(nanoseconds: UInt64(waitDelay * milliToNanoSeconds))

                return nextAction
            }
        }
    }
}
