// swiftlint:disable:this file_name
//  GameLoopMiddleware.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 26/04/2023.
//
import Redux
import Combine

/// Asynchronous game rules
/// - trigger side effects
/// - activate playable cards
/// - dispatch next action
public let gameLoopMiddleware: Middleware<GameState> = { state, _ in
    if let action = NextActionEvaluator().evaluateNextAction(state) {
        Just(action).eraseToAnyPublisher()
    } else if let action = ActiveCardsEvaluator().evaluateActive(state) {
        Just(action).eraseToAnyPublisher()
    } else {
        Empty().eraseToAnyPublisher()
    }
}

private struct NextActionEvaluator {

    func evaluateNextAction(_ state: GameState) -> GameAction? {
        if state.queue.isNotEmpty,
           state.isOver == nil,
           state.chooseOne == nil,
           state.active == nil {
            state.queue[0]
        } else {
            nil
        }
    }
}

private struct ActiveCardsEvaluator {

    func evaluateActive(_ state: GameState) -> GameAction? {
        guard state.queue.isEmpty,
              state.isOver == nil,
              state.chooseOne == nil,
              !state.lastEventIsActiveCard,
              let player = state.turn else {
            return nil
        }

        var activeCards: [String] = []
        let playerObj = state.player(player)
        for card in (playerObj.hand.cards + playerObj.abilities)
        where isCardPlayable(card, player: player, state: state) {
            activeCards.append(card)
        }

        if activeCards.isNotEmpty {
            return GameAction.activateCards(player: player, cards: activeCards)
        }
        return nil
    }

    func isCardPlayable(_ card: String, player: String, state: GameState) -> Bool {
        let cardName = card.extractName()
        guard let cardObj = state.cardRef[cardName] else {
            return false
        }

        let onPlayReqs: [PlayReq] = [.onPlayImmediate, .onPlayAbility, .onPlayHandicap, .onPlayEquipment]
        guard onPlayReqs.contains(where: { onPlayReq in
            cardObj.rules.contains(where: { rule in
                rule.playReqs.contains(onPlayReq)
            })
        }) else {
            return false
        }

        let action = GameAction.play(card, player: player)
        do {
            try action.validate(state: state)
            return true
        } catch {
            print("‼️ invalidate \(action)\treason: \(error)")
            return false
        }
    }
}

private extension GameState {
    var lastEventIsActiveCard: Bool {
        switch event {
        case .activateCards:
            true
        default:
            false
        }
    }
}
