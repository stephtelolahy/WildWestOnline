//
//  ActionPlay.swift
//
//
//  Created by Hugues Telolahy on 20/05/2023.
//

struct ActionPlay: GameReducerProtocol {
    let actor: String
    let card: String

    // swiftlint:disable:next cyclomatic_complexity
    func reduce(state: GameState) throws -> GameState {
        // verify action
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName],
              let playAction = cardObj.actions[.onPlay] else {
            throw GameError.cardNotPlayable(card)
        }

        let ctx: EffectContext = [.actor: actor, .card: card]

        // verify requirements
        let sideEffect = playAction.effect
        for playReq in playAction.playReqs {
            try playReq.match(state: state, ctx: ctx)
        }

        // resolve target
        if case let .target(requiredTarget, _) = sideEffect {
            let resolvedTarget = try requiredTarget.resolve(state: state, ctx: ctx)
            if case let .selectable(pIds) = resolvedTarget {
                var state = state
                let options = pIds.reduce(into: [String: GameAction]()) {
                    let action: GameAction =
                    switch cardObj.type {
                    case .immediate:
                            .playImmediate(card, target: $1, actor: actor)
                    case .handicap:
                            .playHandicap(card, target: $1, actor: actor)
                    default:
                        fatalError("unexpected")
                    }

                    $0[$1] = action
                }
                let chooseOne = try GameAction.validChooseOne(chooser: actor, options: options, state: state)
                state.queue.insert(chooseOne, at: 0)
                return state
            }
        }

        let action: GameAction =
        switch cardObj.type {
        case .immediate:
                .playImmediate(card, actor: actor)
        case .ability:
                .playAbility(card, actor: actor)
        case .equipment:
                .playEquipment(card, actor: actor)
        default:
            fatalError("unexpected")
        }

        // queue play action
        var state = state
        state.queue.insert(action, at: 0)
        return state
    }
}