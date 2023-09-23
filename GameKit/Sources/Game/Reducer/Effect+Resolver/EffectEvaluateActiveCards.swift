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
        precondition(state.isOver == nil)
        precondition(state.chooseOne == nil)
        precondition(state.active == nil)
        precondition(player == state.turn)
        precondition(state.playOrder.contains(player))

        var activeCards: [String] = []
        let playerObj = state.player(player)
        for card in (playerObj.hand.cards + playerObj.abilities)
        where GameAction.validatePlay(card: card, player: player, state: state) {
            activeCards.append(card)
        }

        if activeCards.isNotEmpty {
            return GameAction.activateCards(player: player, cards: activeCards)
        }
        return nil
    }
}
