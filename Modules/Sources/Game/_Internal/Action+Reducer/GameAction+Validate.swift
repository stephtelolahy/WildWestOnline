//
//  GameAction+Validate.swift
//  
//
//  Created by Hugues Telolahy on 08/07/2023.
//

extension GameAction {
    func validate(state: GameState) throws {
        var state = try reduce(state: state)
        if state.queue.isNotEmpty {
            let nextAction = state.queue.remove(at: 0)
            switch nextAction {
            case let .chooseOne(_, options):
                for (_, option) in options {
                    try option.validate(state: state)
                }

            default:
                try nextAction.validate(state: state)
            }
        }
    }
}

extension GameAction {
    static func validChooseOne(
        chooser: String,
        options: [String: GameAction],
        state: GameState
    ) throws -> GameAction {
        var validOptions: [String: GameAction] = [:]
        for (key, action) in options {
            do {
                try action.validate(state: state)
            } catch {
                print("!!! invalidate \(action) reason: \(error)")
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
