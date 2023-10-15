//
//  ActionPlay.swift
//
//
//  Created by Hugues Telolahy on 20/05/2023.
//

struct ActionPlay: GameActionReducer {
    let player: String
    let card: String

    // swiftlint:disable:next cyclomatic_complexity
    func reduce(state: GameState) throws -> GameState {
        // verify action
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName] else {
            throw GameError.cardNotPlayable(card)
        }

        guard let playRule = cardObj.rules.first(where: { rule in
            PlayReq.onPlays.contains(rule.key)
        }) else {
            throw GameError.cardNotPlayable(card)
        }

        // verify requirements
        // TODO: verify requirement
        let playerContext = ArgPlayerContext(actor: player)
//        let playReqContext = PlayReqContext(actor: player)
//        for playReq in playRule.playReqs where !PlayReq.onPlayReqs.contains(playReq) {
//            try playReq.match(state: state, ctx: playReqContext)
//        }

        // resolve target
        let sideEffect = playRule.value
        if case let .target(requiredTarget, _) = sideEffect {
            let resolvedTarget = try requiredTarget.resolve(state: state, ctx: playerContext)
            if case let .selectable(pIds) = resolvedTarget {
                var state = state
                let options = pIds.reduce(into: [String: GameAction]()) {
                    let action: GameAction =
                    switch playRule.key {
                    case .onPlayImmediate:
                            .playImmediate(card, target: $1, player: player)
                    case .onPlayHandicap:
                            .playHandicap(card, target: $1, player: player)
                    default:
                        fatalError("unexpected")
                    }

                    $0[$1] = action
                }
                let chooseOne = try GameAction.validateChooseOne(chooser: player, options: options, state: state)
                state.queue.insert(chooseOne, at: 0)
                return state
            }
        }

        let action: GameAction =
        switch playRule.key {
        case .onPlayImmediate:
                .playImmediate(card, player: player)
        case .onPlayAbility:
                .playAbility(card, player: player)
        case .onPlayEquipment:
                .playEquipment(card, player: player)
        default:
            fatalError("unexpected")
        }

        // queue play action
        var state = state
        state.queue.insert(action, at: 0)
        return state
    }
}

extension GameState {
    mutating func queueOnPlayEffect(
        card: String,
        player: String,
        target: String? = nil,
        state: GameState
    ) {
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName],
              let playRule = cardObj.rules.first(where: { rule in
                  PlayReq.onPlays.contains(rule.key)
              }) else {
            print("!! missing onPlay effects")
            return
        }

        var ctx = EffectContext(actor: player, card: card)
        let playerContext = ArgPlayerContext(actor: player)

        var sideEffect = playRule.value
        if case let .target(requiredTarget, childEffect) = sideEffect,
           let resolvedTarget = try? requiredTarget.resolve(state: state, ctx: playerContext),
           case .selectable = resolvedTarget {
            if let target {
                ctx.target = target
            }
            sideEffect = childEffect
        }

        let triggered = GameAction.effect(sideEffect, ctx: ctx)
        queue.insert(triggered, at: 0)
    }
}

extension PlayReq {
    static let onPlays: [Self] = [.onPlayImmediate, .onPlayAbility, .onPlayHandicap, .onPlayEquipment]
}
