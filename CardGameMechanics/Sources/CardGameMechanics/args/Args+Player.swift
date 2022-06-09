//
//  Arg+Player.swift
//  GameEngine
//
//  Created by TELOLAHY Hugues Stéphano on 23/04/2022.
//
import CardGameCore
import ExtensionsKit

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
}

extension Args {
    
    /// resolve player argument
    static func resolvePlayer<T: Effect>(
        _ player: String,
        copyWithPlayer: @escaping (String) -> T,
        ctx: State,
        actor: String,
        selectedArg: String?
    ) -> EffectResult {
        switch resolvePlayer(player, ctx: ctx, actor: actor) {
            
        case let .success(data):
            switch data {
            case let .identified(pIds):
                let effects = pIds.map { copyWithPlayer($0) }
                return .resolving(effects)
                
            case let .selectable(pIds):
                if let selectedId = selectedArg,
                    pIds.contains(selectedId) {
                    let copy = copyWithPlayer(selectedId)
                    return .resolving([copy])
                } else {
                    let options = pIds.map { Choose(value: $0, actor: actor) }
                    return .suspended(options)
                }
            }
            
        case let .failure(error):
            return .failure(error)
        }
    }
    
    static func isPlayerResolved(_ player: String, ctx: State) -> Bool {
        ctx.players.contains { $0.key == player }
    }
}

private extension Args {
    
    enum PlayerResolved {
        case identified([String])
        case selectable([String])
    }
    
    static func resolvePlayer(_ player: String, ctx: State, actor: String) -> Result<PlayerResolved, Error> {
        switch player {
        case playerActor:
            return .success(.identified([actor]))
            
        case playerOthers:
            let others = Array(ctx.playOrder.starting(with: actor).dropFirst())
            return .success(.identified(others))
            
        case playerAll:
            let all = ctx.playOrder.starting(with: actor)
            return .success(.identified(all))
            
        case playerNext:
            guard let turn = ctx.turn else {
                fatalError(.turnUndefined)
            }
            
            let next = ctx.playOrder.element(after: turn)
            return .success(.identified([next]))
            
        case playerSelectAny:
            let others = ctx.playOrder.filter { $0 != actor }
            return .success(.selectable(others))
            
        case playerSelectReachable:
            let weapon = ctx.player(actor).weapon
            return resolvePlayerAtDistance(weapon, ctx: ctx, actor: actor)
            
        case playerSelectAt1:
            return resolvePlayerAtDistance(1, ctx: ctx, actor: actor)
            
        default:
            /// assume identified player
            guard isPlayerResolved(player, ctx: ctx) else {
                fatalError(.playerValueInvalid(player))
            }
            
            return .success(.identified([player]))
        }
    }
    
    static func resolvePlayerAtDistance(_ distance: Int, ctx: State, actor: String) -> Result<PlayerResolved, Error> {
        let players = ctx.playersAt(distance, actor: actor)
        guard !players.isEmpty else {
            return .failure(ErrorNoPlayersAtRange(distance: distance))
        }
        
        return .success(.selectable(players))
    }
}
