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
        var newState = try reducer().reduce(state: state)
        newState.players = try PlayersState.reducer(state.players, self)
        newState.cardLocations = try CardLocationsState.reducer(state.cardLocations, self)
        return newState
    }
}

private extension GameAction {
    // swiftlint:disable:next cyclomatic_complexity
    func reducer() -> GameActionReducer {
        switch self {
        case let .play(card, player):
            ActionPlay(player: player, card: card)

        case let .group(actions):
            ActionGroup(children: actions)

        case let .startTurn(player):
            ActionStartTurn(player: player)

        case .endTurn:
            ActionEndTurn()

        case let .eliminate(player):
            ActionEliminate(player: player)

        case let .effect(effect, ctx):
            ActionResolveEffect(effect: effect, ctx: ctx)

        case let .chooseOne(type, options, player):
            ActionChooseOne(type: type, options: options, player: player)

        case let .choose(option, player):
            ActionChoose(player: player, option: option)

        case let .activate(cards, player):
            ActionActivate(player: player, cards: cards)

        case let .cancel(action):
            ActionCancel(action: action)

        case let .counterShoot(action):
            ActionCounterShoot(action: action)

        case let .setGameOver(winner):
            ActionSetGameOver(winner: winner)

        default:
            ActionIdentity()
        }
    }
}

private struct ActionIdentity: GameActionReducer {
    func reduce(state: GameState) throws -> GameState {
        state
    }
}
