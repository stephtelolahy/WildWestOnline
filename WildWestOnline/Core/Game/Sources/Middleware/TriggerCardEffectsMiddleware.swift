// swiftlint:disable:this file_name
//
//  TriggerCardEffectsMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//

import Redux

extension Middlewares {
    static func triggerCardEffects() -> Middleware<GameState> {
        { state, action in
            guard let action = action as? GameAction else {
                return nil
            }

            var triggered: [GameAction] = []

            // active players
            for player in state.round.playOrder {
                let playerObj = state.player(player)
                let triggerableCards = state.field.inPlay.get(player) + playerObj.abilities
                for card in triggerableCards {
                    let actions = state.triggeredEffects(by: card, player: player, event: action)
                    triggered.append(contentsOf: actions)
                }
            }

            // just eliminated player
            if case let .eliminate(player) = action {
                let playerObj = state.player(player)
                let triggerableCards = playerObj.abilities
                for card in triggerableCards {
                    let actions = state.triggeredEffects(by: card, player: player, event: action)
                    triggered.append(contentsOf: actions)
                }
            }

            // sort triggered by priority
            triggered = state.sortedByPriority(triggered)

            // return triggered effect(s)
            if triggered.isEmpty {
                return nil
            } else if triggered.count == 1 {
                return triggered[0]
            } else {
                return GameAction.group(triggered)
            }
        }
    }
}

private extension GameState {
    func triggeredEffects(
        by card: String,
        player: String,
        event: GameAction
    ) -> [GameAction] {
        let state = self
        let cardName = card.extractName()
        guard let cardObj = state.config.cards[cardName] else {
            return []
        }

        let playReqContext = PlayReqContext(actor: player, event: event)
        var actions: [GameAction] = []
        for rule in cardObj.rules {
            guard rule.playReqs.allSatisfy({ $0.match(state: state, ctx: playReqContext) }) else {
                continue
            }

            let ctx = EffectContext(
                sourceEvent: event,
                sourceActor: player,
                sourceCard: card,
                linkedToShoot: state.linkedToShoot(event: event)
            )

            actions.append(.effect(rule.effect, ctx: ctx))
        }

        return actions
    }

    func linkedToShoot(event: GameAction) -> String? {
        guard case let .effect(cardEffect, ctx) = event,
              case .shoot = cardEffect else {
            return nil
        }

        return ctx.resolvingTarget
    }

    func sortedByPriority(_ actions: [GameAction]) -> [GameAction] {
        let state = self
        return actions.sorted { action1, action2 in
            guard case let .effect(_, ctx1) = action1,
                  case let .effect(_, ctx2) = action2,
                  let cardObj1 = state.config.cards[ctx1.sourceCard.extractName()],
                  let cardObj2 = state.config.cards[ctx2.sourceCard.extractName()] else {
                fatalError("invalid triggered effect")
            }
            return cardObj1.priority < cardObj2.priority
        }
    }
}
