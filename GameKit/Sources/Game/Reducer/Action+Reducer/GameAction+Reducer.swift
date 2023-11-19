//
//  GameAction+Reducer.swift
//
//
//  Created by Hugues Telolahy on 03/06/2023.
//

protocol GameActionReducer {
    func reduce(state: GameState) throws -> GameState
}

extension GameAction {
    func reduce(state: GameState) throws -> GameState {
        try reducer().reduce(state: state)
    }
}

private extension GameAction {
    // swiftlint:disable:next cyclomatic_complexity
    func reducer() -> GameActionReducer {
        switch self {
        case let .play(card, player):
            ActionPlay(player: player, card: card)

        case let .playImmediate(card, target, player):
            ActionPlayImmediate(player: player, card: card, target: target)

        case let .playAbility(card, player):
            ActionPlayAbility(player: player, card: card)

        case let .playEquipment(card, player):
            ActionPlayEquipment(player: player, card: card)

        case let .playHandicap(card, target, player):
            ActionPlayHandicap(player: player, card: card, target: target)

        case let .heal(amount, player):
            ActionHeal(player: player, amount: amount)

        case let .damage(amount, player):
            ActionDamage(player: player, amount: amount)

        case let .discardHand(card, player):
            ActionDiscardHand(player: player, card: card)

        case let .revealHand(card, player):
            ActionRevealHand(card: card, player: player)

        case let .discardInPlay(card, player):
            ActionDiscardInPlay(player: player, card: card)

        case let .drawDeck(player):
            ActionDrawDeck(player: player)

        case let .drawArena(card, player):
            ActionDrawArena(player: player, card: card)

        case let .drawHand(card, target, player):
            ActionDrawHand(player: player, target: target, card: card)

        case let .drawInPlay(card, target, player):
            ActionDrawInPlay(player: player, target: target, card: card)

        case let .passInPlay(card, target, player):
            ActionPassInPlay(card: card, target: target, player: player)

        case .discover:
            ActionDiscover()

        case .putBack:
            ActionPutBack()

        case .draw:
            ActionDraw()

        case let .group(actions):
            ActionGroup(children: actions)

        case let .setTurn(player):
            ActionSetTurn(player: player)

        case let .eliminate(player):
            ActionEliminate(player: player)

        case let .effect(effect, ctx):
            ActionResolveEffect(effect: effect, ctx: ctx)

        case let .chooseOne(player, options):
            ActionChooseOne(chooser: player, options: options)

        case let .activateCards(player, cards):
            ActionActivateCards(player: player, cards: cards)

        case let .cancel(action):
            ActionCancel(action: action)

        case let .setGameOver(winner):
            ActionSetGameOver(winner: winner)

        case let .setAttribute(key, value, player):
            ActionSetAttribute(player: player, key: key, value: value)
        }
    }
}
