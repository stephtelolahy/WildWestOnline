//
//  GameAction+Validate.swift
//
//
//  Created by Hugues Telolahy on 08/07/2023.
//

extension GameAction {
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

    //  swiftlint:disable:next function_parameter_count
    static func validateChooseOne(
        _ options: [String],
        actions: [String: GameAction],
        chooser: String,
        type: ChoiceType,
        state: GameState,
        ctx: EffectContext
    ) throws -> [GameAction] {
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
            return []
        }

        let chooseOne = GameAction.chooseOne(type, options: validOptions, player: chooser)
        let match = GameAction.effect(.matchAction(actions), ctx: ctx)
        return [chooseOne, match]
    }
}

extension GameAction {
    func validate(state: GameState) throws {
        print("⚙️ validate: \(self) ...")
        switch self {
        case .chooseOne,
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
