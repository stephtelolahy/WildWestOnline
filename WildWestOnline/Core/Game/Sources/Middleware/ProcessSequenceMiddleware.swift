//
//  ProcessSequenceMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//

import Foundation
import Redux

public final class ProcessSequenceMiddleware: Middleware<GameState, GameAction> {
    public override func handle(_ action: GameAction, state: GameState) async -> GameAction? {
        switch action {
        case .setGameOver,
                .chooseOne,
                .activate:
            return nil

        default:
            guard let nextAction = state.sequence.first else {
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
