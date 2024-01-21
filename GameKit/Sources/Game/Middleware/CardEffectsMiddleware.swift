//
//  CardEffectsMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//

import Combine
import Redux

public final class CardEffectsMiddleware: Middleware<GameState> {
    override public func handle(action: Action, state: GameState) -> AnyPublisher<Action, Never>? {
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
                  let cardObj1 = state.cardRef[ctx1.card.extractName()],
                  let cardObj2 = state.cardRef[ctx2.card.extractName()] else {
                fatalError("invalid triggered effect")
            }
            return cardObj1.priority < cardObj2.priority
        }
        // </sort triggered by priority>

        if triggered.isEmpty {
            return nil
        } else if triggered.count == 1 {
            return Just(triggered[0]).eraseToAnyPublisher()
        } else {
            return Just(GameAction.group(triggered)).eraseToAnyPublisher()
        }
    }

    private func triggeredEffects(
        by card: String,
        player: String,
        state: GameState,
        event: GameAction
    ) -> [GameAction] {
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName] else {
            return []
        }

        let playReqContext = PlayReqContext(actor: player, event: event)
        var actions: [GameAction] = []
        for rule in cardObj.rules {
            guard rule.playReqs.allSatisfy({ $0.match(state: state, ctx: playReqContext) }) else {
                continue
            }

            let ctx = EffectContext(
                actor: player,
                card: card,
                event: event,
                cancellingAction: cancellingAction(event: event, state: state)
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

    private func cancellingAction(event: GameAction, state: GameState) -> GameAction? {
        if case let .effect(cardEffect, _) = event,
           case .shoot = cardEffect,
           let nextAction = state.sequence.first,
           case .damage = nextAction {
            return nextAction
        }

        return nil
    }
}
