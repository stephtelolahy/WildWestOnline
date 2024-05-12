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
        for key in options {
            guard let action = actions[key] else {
                fatalError("missing action for key \(key)")
            }

            do {
                try action.validate(state: state)
                validOptions.append(key)
                print("🟢 validateOption: \(action)")
            } catch {
                print("🛑 validateOption: \(action)\tthrows: \(error)")
                continue
            }
        }

        guard !validOptions.isEmpty else {
            throw GameError.noValidOption
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
            print("🟢 validatePlay: \(action)")
            return true
        } catch {
            print("🛑 validatePlay: \(action)\tthrows: \(error)")
            return false
        }
    }
}

extension GameAction {
    func validate(state: GameState) throws {
        print("⚙️ validate: \(self) ...")

        // <HACK: Skip validating endTurn's effect>
        if case .effect(_, let ctx) = self,
           ctx.sourceCard == "endTurn" {
            return
        }
        // </HACK: Skip validating endTurn's effect>

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
