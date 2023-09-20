//
//  EffectEvaluateActiveCards.swift
//
//
//  Created by Hugues Stephano TELOLAHY on 11/09/2023.
//

struct EffectEvaluateActiveCards: EffectResolverProtocol {
    func resolve(state: GameState, ctx: EffectContext) throws -> [GameAction] {
        guard let action = evaluateActiveCards(player: ctx.get(.actor), state: state) else {
            return []
        }
        return [action]
    }

    func evaluateActiveCards(player: String, state: GameState) -> GameAction? {
        precondition(state.queue.isEmpty)
        precondition(state.chooseOne == nil)
        precondition(state.active == nil)
        precondition(state.playOrder.contains(player))
        precondition(state.isOver == nil)

        guard player == state.turn else {
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
            print("‼️ isCardPlayable: invalidate \(action)\treason: \(error)")
            return false
        }
    }
}
