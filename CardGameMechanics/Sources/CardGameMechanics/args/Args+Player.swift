//
//  Arg+Player.swift
//  GameEngine
//
//  Created by TELOLAHY Hugues Stéphano on 23/04/2022.
//
import CardGameCore

/// Effect's player argument
public extension Args {
    
    /// who is playing the card
    static let playerActor = "PLAYER_ACTOR"
    
    /// other players
    static let playerOthers = "PLAYER_OTHERS"
    
    /// all players
    static let playerAll = "PLAYER_ALL"
    
    /// player after current turn
    static let playerNext = "PLAYER_NEXT"
    
    /// select any other player
    static let playerSelectAny = "PLAYER_SELECT_ANY"
    
    /// select any reachable player
    static let playerSelectReachable = "PLAYER_SELECT_REACHABLE"
    
    /// select any player at distance of 1
    static let playerSelectAt1 = "PLAYER_SELECT_AT_1"
    
    /// previous effect's target
    static let playerTarget = "PLAYER_TARGET"
}

extension Args {
    
    /// resolve player argument
    static func resolvePlayer<T: Effect>(
        _ player: String,
        copyWithPlayer: @escaping (String) -> T,
        state: State,
        ctx: PlayContext
    ) -> EffectResult {
        switch resolvePlayer(player, state: state, ctx: ctx) {
            
        case let .success(data):
            switch data {
            case let .identified(pIds):
                let effects = pIds.map { copyWithPlayer($0) }
                return .resolving(effects)
                
            case let .selectable(pIds):
                if let selectedId = ctx.selectedArg,
                    pIds.contains(selectedId) {
                    let copy = copyWithPlayer(selectedId)
                    return .resolving([copy])
                } else {
                    let options = pIds.map { Choose(value: $0, actor: ctx.actor) }
                    return .suspended(options)
                }
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
    
    static func resolvePlayer(_ player: String, state: State, ctx: PlayContext) -> Result<PlayerResolved, Error> {
        switch player {
        case playerActor:
            return .success(.identified([ctx.actor]))
            
        case playerOthers:
            let others = Array(state.playOrder.starting(with: ctx.actor).dropFirst())
            return .success(.identified(others))
            
        case playerAll:
            let all = state.playOrder.starting(with: ctx.actor)
            return .success(.identified(all))
            
        case playerNext:
            guard let turn = state.turn else {
                fatalError(.turnValueInvalid)
            }
            
            let next = state.playOrder.element(after: turn)
            return .success(.identified([next]))
            
        case playerSelectAny:
            let others = state.playOrder.filter { $0 != ctx.actor }
            return .success(.selectable(others))
            
        case playerSelectReachable:
            let weapon = state.player(ctx.actor).weapon
            return resolvePlayerAtDistance(weapon, state: state, actor: ctx.actor)
            
        case playerSelectAt1:
            return resolvePlayerAtDistance(1, state: state, actor: ctx.actor)
            
        case playerTarget:
            guard let target = ctx.target else {
                fatalError(.contextTargetNotFound)
            }
            
            return .success(.identified([target]))
            
        default:
            /// assume identified player
            guard isPlayerResolved(player, state: state) else {
                fatalError(.playerValueInvalid(player))
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
