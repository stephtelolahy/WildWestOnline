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
        var state = state
        state = try reducer().reduce(state: state)
        return state
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
        case let .heal(value, player):
            ActionHeal(player: player, value: value)
        case let .damage(value, player):
            ActionDamage(player: player, value: value)
        case let .discardHand(card, player):
            ActionDiscardHand(player: player, card: card)
        case let .discardInPlay(card, player):
            ActionDiscardInPlay(player: player, card: card)
        case let .draw(player):
            ActionDraw(player: player)
        case let .stealHand(card, target, player):
            ActionStealHand(player: player, target: target, card: card)
        case let .stealInPlay(card, target, player):
            ActionStealInPlay(player: player, target: target, card: card)
        case let .passInplay(card, target, player):
            ActionPassInPlay(card: card, target: target, player: player)
        case .discover:
            ActionDiscover()
        case .luck:
            ActionLuck()
        case let .chooseArena(card, player):
            ActionChooseArena(player: player, card: card)
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
