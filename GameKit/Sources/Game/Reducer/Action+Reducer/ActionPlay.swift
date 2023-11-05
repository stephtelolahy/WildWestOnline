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

        var sideEffect = playRule.effect

        // verify requirements
        let playReqContext = PlayReqContext(actor: player)
        for playReq in playRule.playReqs where !PlayReq.onPlays.contains(playReq) {
            try playReq.throwingMatch(state: state, ctx: playReqContext)
        }

        // resolve target
        if case let .target(requiredTarget, _) = sideEffect {
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
                    if playRule.isMatching(.onPlayImmediate) {
                        .playImmediate(card, target: $1, player: player)
                    } else if playRule.isMatching(.onPlayHandicap) {
                        .playHandicap(card, target: $1, player: player)
                    } else {
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
        if playRule.isMatching(.onPlayImmediate) {
            .playImmediate(card, player: player)
        } else if playRule.isMatching(.onPlayAbility) {
            .playAbility(card, player: player)
        } else if playRule.isMatching(.onPlayEquipment) {
            .playEquipment(card, player: player)
        } else {
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
        state: GameState,
        event: GameAction
    ) {
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName],
              let playRule = cardObj.rules.first(where: { $0.isPlayRule() }) else {
            print("!! missing onPlay effects")
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
        queue.insert(triggered, at: 0)
    }
}

private extension PlayReq {
    static let onPlays: [Self] = [.onPlayImmediate, .onPlayAbility, .onPlayHandicap, .onPlayEquipment]
}

private extension CardRule {
    func isPlayRule() -> Bool {
        playReqs.contains(where: { PlayReq.onPlays.contains($0) })
    }

    func isMatching(_ playReq: PlayReq) -> Bool {
        playReqs.contains(where: { $0 == playReq })
    }
}
