//
//  GameAction+Validate.swift
//
//
//  Created by Hugues Telolahy on 08/07/2023.
//

extension GameAction {
    func validate(state: GameState) throws {
        switch self {
        case .activateCards,
                .chooseOne,
                .setGameOver:
            return

        default:
            var state = try reduce(state: state)
            guard state.queue.isNotEmpty else {
                return
            }

            let next = state.queue.removeFirst()
            try next.validate(state: state)
        }
    }
}

extension GameAction {
    static func buildChooseOne(
        chooser: String,
        options: [String: GameAction],
        state: GameState
    ) throws -> GameAction {
        var validOptions: [String: GameAction] = [:]
        for (key, action) in options {
            do {
                try action.validate(state: state)
            } catch {
                print("‼️ buildChooseOne: invalidate \(action)\treason: \(error)")
                continue
            }

            validOptions[key] = action
            if case let .resolve(effect, ctx) = action {
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
}
