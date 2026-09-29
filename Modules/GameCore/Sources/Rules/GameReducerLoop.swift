//
//  GameReducerLoop.swift
//
//  Created by Hugues Telolahy on 28/10/2024.
//
import Redux
extension GameFeature {
    /// Schedules the game engine: after each action, waits for the animation delay,
    /// then dispatches what the engine decides to do next (see `nextAction(after:dependencies:)` and `autoMove()`).
    static func reducerLoop(
        into state: inout State,
        action: Action,
        dependencies: Dependencies
    ) -> Effect<Action> {
        let state = state
        return .group([
            .run {
                if action.isAnimatable {
                    await state.waitActionDelay()
                }
                return state.nextAction(after: action, dependencies: dependencies)
            },
            .run {
                guard let move = state.autoMove() else {
                    return nil
                }
                await state.waitActionDelay()
                return move
            }
        ])
    }
}

private extension GameFeature.State {
    func waitActionDelay() async {
        try? await Task.sleep(nanoseconds: UInt64(actionDelayMilliSeconds * 1_000_000))
    }
}

private extension GameFeature.Action {
    var isAnimatable: Bool {
        guard selectors.isEmpty else {
            return false
        }

        switch name {
        case .play,
                .equip,
                .handicap,
                .drawDeck,
                .drawDiscard,
                .drawDiscovered,
                .draw,
                .stealHand,
                .stealInPlay,
                .passInPlay,
                .discardHand,
                .discardInPlay,
                .discover:
            return true

        default:
            return false
        }
    }
}
