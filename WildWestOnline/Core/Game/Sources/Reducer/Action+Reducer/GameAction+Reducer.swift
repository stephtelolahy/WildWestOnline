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
        newState.field = try FieldState.reducer(state.field, self)
        newState.round = try RoundState.reducer(state.round, self)
        return newState
    }
}

private extension GameAction {
    func reducer() -> GameActionReducer {
        switch self {
        case let .play(card, player):
            ActionPlay(player: player, card: card)

        case let .group(actions):
            ActionGroup(children: actions)

        case let .effect(effect, ctx):
            ActionResolveEffect(effect: effect, ctx: ctx)

        case let .choose(option, player):
            ActionChoose(player: player, option: option)

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
