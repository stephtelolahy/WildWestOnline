//
//  HandlerTriggeredEffects.swift
//
//
//  Created by Hugues Telolahy on 03/11/2023.
//

struct HandlerTriggeredEffects: GameActionHandler {
    func handle(action: GameAction, state: GameState) -> GameAction? {
        var triggered: [GameAction] = []

        // active players
        for player in state.playOrder {
            let playerObj = state.player(player)
            let cards = triggerableCardsOfActivePlayer(playerObj, state: state)
            for card in cards {
                if let action = triggeredEffect(by: card, player: player, state: state) {
                    triggered.append(action)
                }
            }
        }

        // just eliminated player
        if case let .eliminate(player) = action {
            let playerObj = state.player(player)
            let cards = triggerableCardsOfEliminatedPlayer(playerObj)
            for card in cards {
                if let action = triggeredEffect(by: card, player: player, state: state) {
                    triggered.append(action)
                }
            }
        }

        // Ignore empty
        guard triggered.isNotEmpty else {
            return nil
        }

        return .group(triggered)
    }

    private func triggeredEffect(by card: String, player: String, state: GameState) -> GameAction? {
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName] else {
            return nil
        }

        let playReqContext = PlayReqContext(actor: player)
        for rule in cardObj.rules {
            guard rule.playReqs.allSatisfy({ $0.match(state: state, ctx: playReqContext) }) else {
                continue
            }
            
            let ctx = EffectContext(
                actor: player,
                card: card,
                event: eventForTriggeredEffect(state: state),
                cancellingAction: cancellingActionForTriggeredEffect(state: state)
            )

            return GameAction.effect(rule.effect, ctx: ctx)
        }

        return nil
    }

    private func triggerableCardsOfActivePlayer(_ playerObj: Player, state: GameState) -> [String] {
        playerObj.inPlay.cards
        // TODO: sort abilities by priority
        + playerObj.attributes.map(\.key)
        + playerObj.hand.cards.filter { state.isCardCounteringEffectOnPlay($0) }
    }

    private func triggerableCardsOfEliminatedPlayer(_ playerObj: Player) -> [String] {
        playerObj.attributes.map(\.key)
    }

    private func cancellingActionForTriggeredEffect(state: GameState) -> GameAction? {
        if let event = state.event,
           case let .effect(cardEffect, _) = event,
           case .shoot = cardEffect,
           let nextAction = state.queue.first,
           case .damage = nextAction {
            return nextAction
        }

        return nil
    }

    private func eventForTriggeredEffect(state: GameState) -> GameAction {
        state.event!
    }
}

private extension GameState {
    func isCardCounteringEffectOnPlay(_ card: String) -> Bool {
        let cardName = card.extractName()
        guard let cardObj = cardRef[cardName] else {
            return false
        }

        return cardObj.rules.contains(where: {
            if $0.playReqs.contains(.playImmediate),
               case .counterShoot = $0.effect {
                return true
            } else {
                return false
            }
        })
    }
}
