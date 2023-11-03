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
        for (playReq, effect) in cardObj.rules where  playReq.match(state: state, ctx: playReqContext) {
            let cancellingAction = cancellingActionForTriggeredEffect(state: state)
            let ctx = EffectContext(actor: player, card: card, cancellingAction: cancellingAction)
            return GameAction.effect(effect, ctx: ctx)
        }

        return nil
    }

    private func triggerableCardsOfActivePlayer(_ playerObj: Player, state: GameState) -> [String] {
        playerObj.inPlay.cards
        + playerObj.abilities
        + playerObj.hand.cards.filter { state.isCardCancellingEffectOnPlay($0) }
    }

    private func triggerableCardsOfEliminatedPlayer(_ playerObj: Player) -> [String] {
        playerObj.abilities
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
}

private extension GameState {
    func isCardCancellingEffectOnPlay(_ card: String) -> Bool {
        let cardName = card.extractName()
        guard let cardObj = cardRef[cardName] else {
            return false
        }

        return cardObj.rules.contains(where: {
            if $0.key == .onPlayImmediate,
                case .cancel = $0.value {
                return true
            } else {
                return false
            }
        })
    }
}
