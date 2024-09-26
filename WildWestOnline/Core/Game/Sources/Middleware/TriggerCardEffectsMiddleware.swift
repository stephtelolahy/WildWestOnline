//
//  TriggerCardEffectsMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 27/11/2023.
//

import Combine
import Redux

extension Middlewares {
    static func triggerCardEffects() -> Middleware<GameState> {
        { state, action in
            guard let action = action as? GameAction else {
                return Empty().eraseToAnyPublisher()
            }

            var triggered: [GameAction] = []

            // active players
            for player in state.round.playOrder {
                let playerObj = state.player(player)
                let triggerableCards = state.player(player).inPlay + playerObj.abilities
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
//            triggered = state.sortedByPriority(triggered)

            // return triggered effects
            guard triggered.isNotEmpty else {
                return Empty().eraseToAnyPublisher()
            }

            return Just(GameAction.queue(triggered)).eraseToAnyPublisher()
        }
    }
}

private extension GameState {
    func triggeredEffects(
        by card: String,
        player: String,
        event: GameAction
    ) -> [GameAction] {
        /*
        let state = self
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
                sourceCard: card
            )

            actions.append(.prepareEffect(rule.effect, ctx: ctx))
        }

        return actions
         */
        []
    }

    /*
    func sortedByPriority(_ actions: [GameAction]) -> [GameAction] {
        let state = self
        return actions.sorted { action1, action2 in
            guard case let .prepareEffect(_, ctx1) = action1,
                  case let .prepareEffect(_, ctx2) = action2,
                  let cardObj1 = state.cards[ctx1.sourceCard.extractName()],
                  let cardObj2 = state.cards[ctx2.sourceCard.extractName()] else {
                fatalError("invalid triggered effect")
            }
            return cardObj1.priority < cardObj2.priority
        }
    }
     */
}
