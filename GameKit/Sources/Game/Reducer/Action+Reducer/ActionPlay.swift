//
//  ActionPlay.swift
//
//
//  Created by Hugues Telolahy on 20/05/2023.
//

struct ActionPlay: GameReducerProtocol {
    let player: String
    let card: String

    // swiftlint:disable:next cyclomatic_complexity
    func reduce(state: GameState) throws -> GameState {
        // verify action
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName] else {
            throw GameError.cardNotPlayable(card)
        }

        let onPlayReqs: [PlayReq] = [.onPlayImmediate, .onPlayAbility, .onPlayHandicap, .onPlayEquipment]
        guard let playRule: CardRule = cardObj.rules.first(where: { rule in
            rule.playReqs.contains(where: {
                onPlayReqs.contains($0)
            })
        }) else {
            throw GameError.cardNotPlayable(card)
        }

        // verify requirements
        let ctx: EffectContext = [.actor: player, .card: card]
        for playReq in playRule.playReqs where !onPlayReqs.contains(playReq) {
            try playReq.match(state: state, ctx: ctx)
        }

        // resolve target
        let sideEffect = playRule.effect
        if case let .target(requiredTarget, _) = sideEffect {
            let resolvedTarget = try requiredTarget.resolve(state: state, ctx: ctx)
            if case let .selectable(pIds) = resolvedTarget {
                var state = state
                let options = pIds.reduce(into: [String: GameAction]()) {
                    let action: GameAction =
                    switch playRule.playReqs.first {
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
        switch playRule.playReqs.first {
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
        playReq: PlayReq,
        card: String,
        player: String,
        target: String? = nil,
        state: GameState
    ) {
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName],
              let playRule: CardRule = cardObj.rules.first(where: { rule in
                  rule.playReqs.contains(playReq)
              }) else {
            print("!! missing onPlay effects")
            return
        }

        var ctx: EffectContext = [.actor: player, .card: card]

        var sideEffect = playRule.effect
        if case let .target(requiredTarget, childEffect) = sideEffect,
           let resolvedTarget = try? requiredTarget.resolve(state: state, ctx: ctx),
           case .selectable = resolvedTarget {
            ctx[.target] = target
            sideEffect = childEffect
        }

        let triggered = GameAction.effect(sideEffect, ctx: ctx)
        queue.insert(triggered, at: 0)
    }
}
