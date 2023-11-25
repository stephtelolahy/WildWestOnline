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
        // verify play rule
        var cardName = card.extractName()
        var aliasCardName: String?

        // <resolve card alias>
        let playReqContext = PlayReqContext(actor: player, event: .play(card, player: player))
        if let alias = state.alias(for: card, player: player, ctx: playReqContext) {
            cardName = alias
            aliasCardName = alias
        }
        // </resolve card alias>

        guard let cardObj = state.cardRef[cardName],
              let playRule = cardObj.rules.first(where: { $0.isPlayRule() }) else {
            throw GameError.cardNotPlayable(card)
        }

        // verify requirements
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
                    $0[$1] = PlayEffectResolver.playAction(
                        card: card,
                        player: player,
                        playRule: playRule,
                        target: $1,
                        aliasCardName: aliasCardName
                    )
                }
                let chooseOne = try GameAction.validateChooseOne(chooser: player, options: options, state: state)
                var state = state
                state.sequence.insert(chooseOne, at: 0)
                return state
            }
        }

        // queue play action
        let action = PlayEffectResolver.playAction(
            card: card,
            player: player,
            playRule: playRule,
            aliasCardName: aliasCardName
        )
        var state = state
        state.sequence.insert(action, at: 0)
        return state
    }
}

enum PlayEffectResolver {
    static func playAction(
        card: String,
        player: String,
        playRule: CardRule,
        target: String? = nil,
        aliasCardName: String? = nil
    ) -> GameAction {
        if playRule.isMatching(.playImmediate) {
            if let aliasCardName {
                return .playAs(aliasCardName, card: card, target: target, player: player)
            } else {
                return .playImmediate(card, target: target, player: player)
            }
        } else if playRule.isMatching(.playAbility) {
            return .playAbility(card, player: player)
        } else if playRule.isMatching(.playEquipment) {
            return .playEquipment(card, player: player)
        } else if playRule.isMatching(.playHandicap) {
            guard let target else {
                fatalError("missing handicap target")
            }
            return .playHandicap(card, target: target, player: player)
        } else {
            fatalError("unexpected")
        }
    }

    static func triggeredEffect(
        event: GameAction,
        state: GameState
    ) -> [GameAction] {
        // get play rule
        let playRule: CardRule
        let player: String
        let card: String
        var target: String?
        switch event {
        case let .playImmediate(aCard, aTarget, aPlayer):
            player = aPlayer
            card = aCard
            target = aTarget
            let cardName = aCard.extractName()

            guard let cardObj = state.cardRef[cardName],
                  let aRule = cardObj.rules.first(where: { $0.playReqs.contains(.playImmediate) }) else {
                return []
            }

            playRule = aRule

        case let .playAs(aliasCardName, aCard, aTarget, aPlayer):
            player = aPlayer
            card = aCard
            target = aTarget

            guard let cardObj = state.cardRef[aliasCardName],
                  let aRule = cardObj.rules.first(where: { $0.playReqs.contains(.playImmediate) }) else {
                return []
            }

            playRule = aRule

        case let .playAbility(aCard, aPlayer):
            player = aPlayer
            card = aCard
            let cardName = aCard.extractName()
            guard let cardObj = state.cardRef[cardName],
                  let aRule = cardObj.rules.first(where: { $0.playReqs.contains(.playAbility) }) else {
                return []
            }

            playRule = aRule

        case let .playEquipment(aCard, aPlayer):
            player = aPlayer
            card = aCard
            let cardName = aCard.extractName()
            guard let cardObj = state.cardRef[cardName],
                  let aRule = cardObj.rules.first(where: { $0.playReqs.contains(.playEquipment) }) else {
                return []
            }

            playRule = aRule

        case let .playHandicap(aCard, aTarget, aPlayer):
            player = aPlayer
            card = aCard
            target = aTarget
            let cardName = aCard.extractName()
            guard let cardObj = state.cardRef[cardName],
                  let aRule = cardObj.rules.first(where: { $0.playReqs.contains(.playHandicap) }) else {
                return []
            }

            playRule = aRule

        default:
            fatalError("unexpected")
        }

        // get main effect
        var sideEffect = playRule.effect

        // unwrap target effect
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

        return [.effect(sideEffect, ctx: ctx)]
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
        playReqs.contains(playReq)
    }
}
