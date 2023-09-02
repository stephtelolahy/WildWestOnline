//
//  ActionPlay.swift
//
//
//  Created by Hugues Telolahy on 20/05/2023.
//

struct ActionPlay: GameReducerProtocol {
    let actor: String
    let card: String

    // swiftlint:disable:next cyclomatic_complexity function_body_length
    func reduce(state: GameState) throws -> GameState {
        // verify action
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName] else {
            throw GameError.cardNotPlayable(card)
        }

        let playAction: CardAction
        let playMode: PlayMode
        if let immediateAction = cardObj.actions[.onPlay(.immediate)] {
            playAction = immediateAction
            playMode = .immediate
        } else if let abilityAction = cardObj.actions[.onPlay(.ability)] {
            playAction = abilityAction
            playMode = .ability
        } else if let equipmentAction = cardObj.actions[.onPlay(.equipment)] {
            playAction = equipmentAction
            playMode = .equipment
        } else if let handicapAction = cardObj.actions[.onPlay(.handicap)] {
            playAction = handicapAction
            playMode = .handicap
        } else {
            throw GameError.cardNotPlayable(card)
        }

        let ctx: EffectContext = [.actor: actor, .card: card]

        // verify requirements
        var sideEffect = playAction.effect
        for playReq in playAction.playReqs {
            try playReq.match(state: state, ctx: ctx)
        }

        if case let .require(playReq, childEffect) = sideEffect {
            try playReq.match(state: state, ctx: ctx)
            sideEffect = childEffect
        }

        // resolve target
        if case let .target(requiredTarget, _) = sideEffect {
            let resolvedTarget = try requiredTarget.resolve(state: state, ctx: ctx)
            if case let .selectable(pIds) = resolvedTarget {
                var state = state
                let options = pIds.reduce(into: [String: GameAction]()) {
                    let action: GameAction =
                    switch playMode {
                    case .immediate:
                            .playImmediate(card, target: $1, actor: actor)
                    case .handicap:
                            .playHandicap(card, target: $1, actor: actor)
                    default:
                        fatalError("unexpected")
                    }

                    $0[$1] = action
                }
                let chooseOne = try GameAction.buildChooseOne(chooser: actor, options: options, state: state)
                state.queue.insert(chooseOne, at: 0)
                return state
            }
        }

        let action: GameAction =
        switch playMode {
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
