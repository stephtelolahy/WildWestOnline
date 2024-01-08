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
                validOptions[key] = action
            } catch {
                print("‼️ validateChooseOne: \(action)\tthrows: \(error)")
                continue
            }
        }

        guard !validOptions.isEmpty else {
            fatalError("no valid option")
        }

        return .chooseOne(.force, options: validOptions.map(\.key), player: chooser)
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
}

private extension GameAction {
    func validate(state: GameState) throws {
        switch self {
        case .activate,
                .chooseOne,
                .setGameOver:
            return

        default:
            var newState = try reduce(state: state)
            if newState.sequence.isNotEmpty {
                let next = newState.sequence.removeFirst()
                try next.validate(state: newState)
            }
        }
    }
}
