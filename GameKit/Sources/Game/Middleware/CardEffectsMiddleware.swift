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
                if let action = triggeredEffect(by: card, player: player, state: state, event: action) {
                    triggered.append(action)
                }
            }
        }

        // just eliminated player
        if case let .eliminate(player) = action {
            let playerObj = state.player(player)
            let cards = triggerableCardsOfEliminatedPlayer(playerObj)
            for card in cards {
                if let action = triggeredEffect(by: card, player: player, state: state, event: action) {
                    triggered.append(action)
                }
            }
        }

        // Ignore empty
        guard triggered.isNotEmpty else {
            return nil
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

        let cardEffects = GameAction.group(triggered)
        return Just(cardEffects).eraseToAnyPublisher()
    }

    private func triggeredEffect(
        by card: String,
        player: String,
        state: GameState,
        event: GameAction
    ) -> GameAction? {
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName] else {
            return nil
        }

        let playReqContext = PlayReqContext(actor: player, event: event)
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

            return GameAction.effect(rule.effect, ctx: ctx)
        }

        return nil
    }

    private func triggerableCardsOfActivePlayer(_ playerObj: Player, state: GameState) -> [String] {
        playerObj.inPlay.cards + playerObj.attributes.map(\.key)
    }

    private func triggerableCardsOfEliminatedPlayer(_ playerObj: Player) -> [String] {
        playerObj.attributes.map(\.key)
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
