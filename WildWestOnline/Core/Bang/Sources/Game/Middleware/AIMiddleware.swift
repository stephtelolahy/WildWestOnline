//
//  AIMiddleware.swift
//  Bang
//
//  Created by Hugues Telolahy on 27/12/2024.
//

public extension Middlewares {
    static var playAIMove: Middleware<GameState> {
        { state, _ in
            if let pendingChoice = state.pendingChoice,
               state.playMode[pendingChoice.chooser] == .auto,
               let selection = pendingChoice.options.randomElement() {
                try? await Task.sleep(nanoseconds: state.visibleActionDelayMilliSeconds * 1_000_000)
                return GameAction.choose(selection.label, player: pendingChoice.chooser)
            }

            if state.active.isNotEmpty,
               let choice = state.active.first,
               state.playMode[choice.key] == .auto,
               let selection = choice.value.randomElement() {
                try? await Task.sleep(nanoseconds: state.visibleActionDelayMilliSeconds * 1_000_000)
                return GameAction.play(selection, player: choice.key)
            }

            return nil
        }
    }
}
