//
//  PlaySequenceMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//

import Foundation
import Redux

public final class PlaySequenceMiddleware: Middleware<GameState> {
    override public func effect(on action: Action, state: GameState) async -> Action? {
        guard let action = action as? GameAction else {
            return nil
        }

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

            let milliToNanoSeconds = 1000
            try? await Task.sleep(nanoseconds: UInt64(waitDelay * milliToNanoSeconds))

            return nextAction
        }
    }
}
