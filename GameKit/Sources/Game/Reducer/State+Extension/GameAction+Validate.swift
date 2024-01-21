//
//  GameAction+Validate.swift
//
//
//  Created by Hugues Telolahy on 08/07/2023.
//

extension GameAction {
    static func validateOptions(
        _ options: [String],
        actions: [String: GameAction],
        state: GameState
    ) throws -> [String] {
        var validOptions: [String] = []
        var caughtError: Error?
        for key in options {
            guard let action = actions[key] else {
                fatalError("missing action for key \(key)")
            }

            do {
                try action.validate(state: state)
                validOptions.append(key)
            } catch {
                print("🚨 validateOptions: \(action)\tthrows: \(error)")
                caughtError = error
                continue
            }
        }

        guard !validOptions.isEmpty else {
            throw caughtError!
        }

        return validOptions
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
//            print("🚨 validatePlay: \(action)\tthrows: \(error)")
            return false
        }
    }
}

extension GameAction {
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
