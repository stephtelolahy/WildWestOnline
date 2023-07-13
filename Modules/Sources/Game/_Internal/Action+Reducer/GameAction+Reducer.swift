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
            return ActionPlay(actor: actor, card: card)
        case let .playImmediate(card, target, actor):
            return ActionPlayImmediate(actor: actor, card: card, target: target)
        case let .playAbility(card, actor):
            return ActionPlayAbility(actor: actor, card: card)
        case let .playEquipment(card, actor):
            return ActionPlayEquipment(actor: actor, card: card)
        case let .playHandicap(card, target, actor):
            return ActionPlayHandicap(actor: actor, card: card, target: target)
        case let .heal(value, player):
            return ActionHeal(player: player, value: value)
        case let .damage(value, player):
            return ActionDamage(player: player, value: value)
        case let .discard(card, player):
            return ActionDiscard(player: player, card: card)
        case let .draw(player):
            return ActionDraw(player: player)
        case let .steal(card, target, player):
            return ActionSteal(player: player, target: target, card: card)
        case let .passInplay(card, target, player):
            return ActionPassInPlay(card: card, target: target, player: player)
        case .discover:
            return ActionDiscover()
        case .luck:
            return ActionLuck()
        case let .chooseCard(card, player):
            return ActionChooseCard(player: player, card: card)
        case let .group(actions):
            return ActionGroup(children: actions)
        case let .setTurn(player):
            return ActionSetTurn(player: player)
        case let .eliminate(player):
            return ActionEliminate(player: player)
        case let .resolve(effect, ctx):
            return ActionResolve(effect: effect, ctx: ctx)
        case let .chooseOne(player, options):
            return ActionChooseOne(chooser: player, options: options)
        case let .activateCard(player, cards):
            return ActionActivateCard(player: player, cards: cards)
        case let .cancel(arg):
            return ActionCancel(arg: arg)
        case let .setGameOver(winner):
            return ActionSetGameOver(winner: winner)
        default:
            fatalError("unimplemented action \(self)")
        }
    }
}
