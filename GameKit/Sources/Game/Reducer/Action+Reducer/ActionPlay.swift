//
//  ActionPlay.swift
//
//
//  Created by Hugues Telolahy on 20/05/2023.
//

struct ActionPlay: GameActionReducer {
    let player: String
    let card: String

    func reduce(state: GameState) throws -> GameState {
        // verify action
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName] else {
            throw GameError.cardNotPlayable(card)
        }

        guard let playRule = cardObj.rules.first(where: { $0.isPlayRule() }) else {
            throw GameError.cardNotPlayable(card)
        }

        // verify requirements
        let playReqContext = PlayReqContext(actor: player, event: .play(card, player: player))
        for playReq in playRule.playReqs where !PlayReq.playEvents.contains(playReq) {
            try playReq.throwingMatch(state: state, ctx: playReqContext)
        }

        // resolve target
        if case let .target(requiredTarget, _) = playRule.effect {
            let ctx = EffectContext(
                actor: player,
                card: card,
                event: .group([])
            )
            let resolvedTarget = try requiredTarget.resolve(state: state, ctx: ctx)
            if case let .selectable(pIds) = resolvedTarget {
                var state = state
                let options = pIds.reduce(into: [String: GameAction]()) {
                    let action: GameAction =
                    if playRule.isMatching(.playImmediate) {
                        .playImmediate(card, target: $1, player: player)
                    } else if playRule.isMatching(.playHandicap) {
                        .playHandicap(card, target: $1, player: player)
                    } else {
                        fatalError("unexpected")
                    }

                    $0[$1] = action
                }
                let chooseOne = try GameAction.validateChooseOne(chooser: player, options: options, state: state)
                state.sequence.insert(chooseOne, at: 0)
                return state
            }
        }

        let action: GameAction =
        if playRule.isMatching(.playImmediate) {
            .playImmediate(card, player: player)
        } else if playRule.isMatching(.playAbility) {
            .playAbility(card, player: player)
        } else if playRule.isMatching(.playEquipment) {
            .playEquipment(card, player: player)
        } else {
            fatalError("unexpected")
        }

        // queue play action
        var state = state
        state.sequence.insert(action, at: 0)
        return state
    }
}

extension GameState {
    mutating func queueOnPlayEffect(
        card: String,
        player: String,
        target: String?,
        state: GameState,
        event: GameAction
    ) {
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName],
              let playRule = cardObj.rules.first(where: { $0.isPlayRule() }) else {
            return
        }

        // set main effect
        var sideEffect = playRule.effect

        // unwrap target effect, only if provided specific player as target
        if case let .target(_, childEffect) = sideEffect,
           target != nil {
            sideEffect = childEffect
        }

        let ctx = EffectContext(
            actor: player,
            card: card,
            event: event,
            target: target
        )
        let triggered = GameAction.effect(sideEffect, ctx: ctx)
        sequence.insert(triggered, at: 0)
    }
}

private extension PlayReq {
    static let playEvents: [Self] = [
        .playImmediate,
        .playAbility,
        .playHandicap,
        .playEquipment
    ]
}

private extension CardRule {
    func isPlayRule() -> Bool {
        playReqs.contains { PlayReq.playEvents.contains($0) }
    }

    func isMatching(_ playReq: PlayReq) -> Bool {
        playReqs.contains { $0 == playReq }
    }
}
