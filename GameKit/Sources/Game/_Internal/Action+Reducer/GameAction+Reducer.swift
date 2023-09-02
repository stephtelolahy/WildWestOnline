//
//  GameAction+Reducer.swift
//
//
//  Created by Hugues Telolahy on 03/06/2023.
//

extension GameAction {
    func reduce(state: GameState) throws -> GameState {
        var state = state
        state = try reducer().reduce(state: state)
        return state
    }
}

protocol GameReducerProtocol {
    func reduce(state: GameState) throws -> GameState
}

private extension GameAction {
    // swiftlint:disable:next cyclomatic_complexity
    func reducer() -> GameReducerProtocol {
        switch self {
        case let .play(card, actor):
            ActionPlay(actor: actor, card: card)
        case let .playImmediate(card, target, actor):
            ActionPlayImmediate(actor: actor, card: card, target: target)
        case let .playAbility(card, actor):
            ActionPlayAbility(actor: actor, card: card)
        case let .playEquipment(card, actor):
            ActionPlayEquipment(actor: actor, card: card)
        case let .playHandicap(card, target, actor):
            ActionPlayHandicap(actor: actor, card: card, target: target)
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
        case let .steal(card, target, player):
            ActionSteal(player: player, target: target, card: card)
        case let .passInplay(card, target, player):
            ActionPassInPlay(card: card, target: target, player: player)
        case .discover:
            ActionDiscover()
        case .luck:
            ActionLuck()
        case let .chooseCard(card, player):
            ActionChooseCard(player: player, card: card)
        case let .group(actions):
            ActionGroup(children: actions)
        case let .setTurn(player):
            ActionSetTurn(player: player)
        case let .eliminate(player):
            ActionEliminate(player: player)
        case let .resolve(effect, ctx):
            ActionResolve(effect: effect, ctx: ctx)
        case let .chooseOne(player, options):
            ActionChooseOne(chooser: player, options: options)
        case let .activateCards(player, cards):
            ActionActivateCards(player: player, cards: cards)
        case let .cancel(arg):
            ActionCancel(arg: arg)
        case let .setGameOver(winner):
            ActionSetGameOver(winner: winner)
        case let .setAttribute(key, value, player):
            ActionSetAttribute(player: player, key: key, value: value)
        default:
            fatalError("unimplemented action \(self)")
        }
    }
}
