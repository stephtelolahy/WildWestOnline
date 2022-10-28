//
//  Arg+Player.swift
//  GameEngine
//
//  Created by TELOLAHY Hugues Stéphano on 23/04/2022.
//

import CardGameCore

extension Args {
    
    /// resolve player argument
    static func resolvePlayer<T: Effect>(
        _ player: String,
        copy: @escaping (String) -> T,
        ctx: [ContextKey: Any],
        state: State 
    ) -> Result<EffectOutput, Error> {
        switch resolvePlayer(player, ctx: ctx, state: state) {
            
        case let .success(data):
            switch data {
            case let .identified(pIds):
                let effects = pIds.map { copy($0) }
                return .success(EffectOutput(effects: effects))
                
            case let .selectable(pIds):
                let options = pIds.map { Choose(value: $0, actor: ctx.actor, effects: [copy($0)]) }
                return .success(EffectOutput(options: options))
            }
            
        case let .failure(error):
            return .failure(error)
        }
    }
    
    static func isPlayerResolved(_ player: String, state: State) -> Bool {
        state.players.contains { $0.key == player }
    }
}

private extension Args {
    
    enum PlayerResolved {
        case identified([String])
        case selectable([String])
    }
    
    static func resolvePlayer(_ player: String, ctx: [ContextKey: Any], state: State) -> Result<PlayerResolved, Error> {
        switch player {
        case .PLAYER_ACTOR:
            return .success(.identified([ctx.actor]))
            
        case .PLAYER_OTHERS:
            let others = Array(state.playOrder.starting(with: ctx.actor).dropFirst())
            return .success(.identified(others))
            
        case .PLAYER_ALL:
            let all = state.playOrder.starting(with: ctx.actor)
            return .success(.identified(all))
            
        case .PLAYER_DAMAGED:
            let damaged = state.playOrder.starting(with: ctx.actor)
                .filter { state.player($0).health < state.player($0).maxHealth }
            guard !damaged.isEmpty else {
                return .failure(ErrorNoPlayerDamaged())
            }
            
            return .success(.identified(damaged))
            
        case .PLAYER_NEXT:
            guard let turn = state.turn else {
                fatalError(.invalidTurn)
            }
            
            let next = state.playOrder.element(after: turn)
            return .success(.identified([next]))
            
        case .PLAYER_SELECT_ANY:
            let others = state.playOrder.filter { $0 != ctx.stringForKey(.ACTOR) }
            return .success(.selectable(others))
            
        case .PLAYER_SELECT_REACHABLE:
            let weapon = state.player(ctx.actor).weapon
            return resolvePlayerAtDistance(weapon, state: state, actor: ctx.actor)
            
        case .PLAYER_SELECT_AT_1:
            return resolvePlayerAtDistance(1, state: state, actor: ctx.actor)
            
        case .PLAYER_TARGET:
            guard let target = ctx.stringForKey(.TARGET) else {
                fatalError(.missingTarget)
            }
            
            return .success(.identified([target]))
            
        default:
            /// assume identified player
            guard isPlayerResolved(player, state: state) else {
                fatalError(.invalidPlayer(player))
            }
            
            return .success(.identified([player]))
        }
    }
    
    static func resolvePlayerAtDistance(_ distance: Int, state: State, actor: String) -> Result<PlayerResolved, Error> {
        let players = state.playersAt(distance, actor: actor)
        guard !players.isEmpty else {
            return .failure(ErrorNoPlayersAtRange(distance: distance))
        }
        
        return .success(.selectable(players))
    }
}
