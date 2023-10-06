//
//  GameAction+Validate.swift
//
//
//  Created by Hugues Telolahy on 08/07/2023.
//

extension GameAction {
    static func validateChooseOne(
        chooser: String,
        options: [String: GameAction],
        state: GameState
    ) throws -> GameAction {
        var validOptions: [String: GameAction] = [:]
        for (key, action) in options {
            do {
                try action.validate(state: state)
            } catch {
                print("‼️ validateChooseOne: \(action)\tthrows: \(error)")
                continue
            }

            validOptions[key] = action
            if case let .effect(effect, ctx) = action {
                let childActions = try effect
                    .resolve(state: state, ctx: ctx)
                if childActions.count == 1 {
                    validOptions[key] = childActions[0]
                }
            }
        }

        guard !validOptions.isEmpty else {
            throw GameError.noValidOption
        }

        return .chooseOne(player: chooser, options: validOptions)
    }

    static func validatePlay(
        card: String,
        player: String,
        state: GameState
    ) -> Bool {
        let action = GameAction.play(card, player: player)
        do {
            try action.validate(state: state)
            return true
        } catch {
            print("‼️ validatePlay: \(action)\tthrows: \(error)")
            return false
        }
    }

    private func validate(state: GameState) throws {
        switch self {
        case .activateCards,
                .chooseOne,
                .setGameOver:
            return

        default:
            var state = state
            state = try reduce(state: state)
            state.event = self

            if state.queue.isNotEmpty {
                let next = state.queue.removeFirst()
                try next.validate(state: state)
            }
        }
    }
}
