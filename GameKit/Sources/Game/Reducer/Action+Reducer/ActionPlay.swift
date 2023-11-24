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
        guard let playRule = PlayEffectResolver.playRule(card: card, player: player, state: state) else {
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
                let options = pIds.reduce(into: [String: GameAction]()) {
                    $0[$1] = PlayEffectResolver.playEvent(card: card, player: player, playRule: playRule, target: $1)
                }
                let chooseOne = try GameAction.validateChooseOne(chooser: player, options: options, state: state)
                var state = state
                state.sequence.insert(chooseOne, at: 0)
                return state
            }
        }

        // queue play action
        let action = PlayEffectResolver.playEvent(card: card, player: player, playRule: playRule)
        var state = state
        state.sequence.insert(action, at: 0)
        return state
    }
}

enum PlayEffectResolver {
    static func triggeredEffect(
        card: String,
        player: String,
        state: GameState,
        target: String? = nil,
        aliasCardName: String? = nil
    ) -> [GameAction] {
        guard let playRule = playRule(
            card: card,
            player: player,
            state: state,
            aliasCardName: aliasCardName
        ) else {
            return []
        }

        // set main effect
        var sideEffect = playRule.effect

        // unwrap target effect, only if provided specific player as target
        if case let .target(_, childEffect) = sideEffect,
           target != nil {
            sideEffect = childEffect
        }

        let event = playEvent(
            card: card,
            player: player,
            playRule: playRule,
            target: target,
            aliasCardName: aliasCardName
        )
        let ctx = EffectContext(
            actor: player,
            card: card,
            event: event,
            target: target
        )

        return [.effect(sideEffect, ctx: ctx)]
    }

    static func playRule(
        card: String,
        player: String,
        state: GameState,
        aliasCardName: String? = nil
    ) -> CardRule? {
        var cardName = card.extractName()

        if let aliasCardName {
            cardName = aliasCardName
        } else {
            // <resolve card alias>
            let playReqContext = PlayReqContext(actor: player, event: .play(card, player: player))
            if let alias = state.alias(for: card, player: player, ctx: playReqContext) {
                cardName = alias
            }
            // </resolve card alias>
        }

        guard let cardObj = state.cardRef[cardName],
              let playRule = cardObj.rules.first(where: { $0.isPlayRule() }) else {
            return nil
        }

        return playRule
    }

    static func playEvent(
        card: String,
        player: String,
        playRule: CardRule,
        target: String? = nil,
        aliasCardName: String? = nil
    ) -> GameAction {
        if playRule.isMatching(.playImmediate) {
            if let aliasCardName {
                .playAs(aliasCardName, card: card, target: target, player: player)
            } else {
                .playImmediate(card, target: target, player: player)
            }
        } else if playRule.isMatching(.playAbility) {
            .playAbility(card, player: player)
        } else if playRule.isMatching(.playEquipment) {
            .playEquipment(card, player: player)
        } else if playRule.isMatching(.playHandicap) {
            // swiftlint:disable:next force_unwrapping
            .playHandicap(card, target: target!, player: player)
        } else {
            fatalError("unexpected")
        }
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
