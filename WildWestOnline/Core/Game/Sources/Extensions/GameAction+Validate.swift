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
        let action = GameAction.preparePlay(card, player: player)
        do {
            try action.validate(state: state)
//            print("🟢 validatePlay: \(action)")
            return true
        } catch {
//            print("🛑 validatePlay: \(action)\tthrows: \(error)")
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
//                print("🟢 validateOption: \(action)")
            } catch {
//                print("🛑 validateOption: \(action)\tthrows: \(error)")
                continue
            }
        }

        guard !validOptions.isEmpty else {
            return []
        }
/*
        let chooseOne = GameAction.chooseOne(type, options: validOptions, player: chooser)
        let match = GameAction.prepareEffect(.matchAction(actions), ctx: ctx)
        return [chooseOne, match]
 */
        fatalError()
    }
}

extension GameAction {
    func validate(state: GameState) throws {
//        print("⚙️ validate: \(self) ...")
        switch self {
        case .chooseOne,
             .endGame:
            return

        default:
            var newState = try GameState.reducer(state, self)
            if newState.queue.isNotEmpty {
                let next = newState.queue.removeFirst()
                try next.validate(state: newState)
            }
        }
    }
}
