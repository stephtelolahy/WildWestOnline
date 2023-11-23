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
        let effectResolver = PlayEffectResolver(player: player, card: card)
        guard let playRule = effectResolver.playRule(state: state) else {
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
                    $0[$1] = effectResolver.playEvent(playRule: playRule, state: state, target: $1)
                }
                let chooseOne = try GameAction.validateChooseOne(chooser: player, options: options, state: state)
                var state = state
                state.sequence.insert(chooseOne, at: 0)
                return state
            }
        }

        // queue play action
        let action = effectResolver.playEvent(playRule: playRule, state: state)
        var state = state
        state.sequence.insert(action, at: 0)
        return state
    }
}

struct PlayEffectResolver {
    let player: String
    let card: String

    func resolve(state: GameState, target: String? = nil) -> [GameAction] {
        guard let playRule = playRule(state: state) else {
            return []
        }

        // set main effect
        var sideEffect = playRule.effect

        // unwrap target effect, only if provided specific player as target
        if case let .target(_, childEffect) = sideEffect,
           target != nil {
            sideEffect = childEffect
        }

        let event = playEvent(playRule: playRule, state: state, target: target)
        let ctx = EffectContext(
            actor: player,
            card: card,
            event: event,
            target: target
        )

        return [.effect(sideEffect, ctx: ctx)]
    }

    func playRule(state: GameState) -> CardRule? {
        var cardName = card.extractName()

        // <resolve card alias>
        if state.player(player).attributes["calamityJanet"] != nil {
            switch cardName {
            case "missed":
                cardName = "bang"

            case "bang":
                if state.turn != player {
                    cardName = "missed"
                }

            default:
                break
            }
        }
        // </resolve card alias>

        guard let cardObj = state.cardRef[cardName],
              let playRule = cardObj.rules.first(where: { $0.isPlayRule() }) else {
            return nil
        }

        return playRule
    }

    func playEvent(playRule: CardRule, state: GameState, target: String? = nil) -> GameAction {
        if playRule.isMatching(.playImmediate) {
            .playImmediate(card, target: target, player: player)
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
