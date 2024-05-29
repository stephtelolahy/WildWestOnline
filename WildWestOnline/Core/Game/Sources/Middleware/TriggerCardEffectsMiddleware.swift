//
//  TriggerCardEffectsMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//

import Redux

public final class TriggerCardEffectsMiddleware: Middleware<GameState> {
    override public func effect(on action: Action, state: GameState) async -> Action? {
        guard let action = action as? GameAction else {
            return nil
        }

        var triggered: [GameAction] = []

        // active players
        for player in state.playOrder {
            let playerObj = state.player(player)
            let cards = triggerableCardsOfActivePlayer(playerObj, state: state)
            for card in cards {
                let actions = triggeredEffects(by: card, player: player, state: state, event: action)
                triggered.append(contentsOf: actions)
            }
        }

        // just eliminated player
        if case let .eliminate(player) = action {
            let playerObj = state.player(player)
            let cards = triggerableCardsOfEliminatedPlayer(playerObj)
            for card in cards {
                let actions = triggeredEffects(by: card, player: player, state: state, event: action)
                triggered.append(contentsOf: actions)
            }
        }

        // <sort triggered by priority>
        triggered.sort { action1, action2 in
            guard case let .effect(_, ctx1) = action1,
                  case let .effect(_, ctx2) = action2,
                  let cardObj1 = state.cards[ctx1.sourceCard.extractName()],
                  let cardObj2 = state.cards[ctx2.sourceCard.extractName()] else {
                fatalError("invalid triggered effect")
            }
            return cardObj1.priority < cardObj2.priority
        }
        // </sort triggered by priority>

        if triggered.isEmpty {
            return nil
        } else if triggered.count == 1 {
            return triggered[0]
        } else {
            return GameAction.group(triggered)
        }
    }

    private func triggeredEffects(
        by card: String,
        player: String,
        state: GameState,
        event: GameAction
    ) -> [GameAction] {
        let cardName = card.extractName()
        guard let cardObj = state.cards[cardName] else {
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
                linkedToShoot: linkedToShoot(event: event, state: state)
            )

            actions.append(.effect(rule.effect, ctx: ctx))
        }

        return actions
    }

    private func triggerableCardsOfActivePlayer(_ playerObj: Player, state: GameState) -> [String] {
        playerObj.inPlay + playerObj.abilities
    }

    private func triggerableCardsOfEliminatedPlayer(_ playerObj: Player) -> [String] {
        Array(playerObj.abilities)
    }

    private func linkedToShoot(event: GameAction, state: GameState) -> String? {
        guard case let .effect(cardEffect, ctx) = event,
              case .shoot = cardEffect else {
            return nil
        }

        return ctx.resolvingTarget
    }
}
