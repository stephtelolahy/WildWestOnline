//
//  Arg+Player.swift
//  GameEngine
//
//  Created by TELOLAHY Hugues Stéphano on 23/04/2022.
//
// swiftlint:disable identifier_name

import CardGameCore

public extension String {
    
    /// who is playing the card
    static let PLAYER_ACTOR = "PLAYER_ACTOR"
    
    /// other players
    static let PLAYER_OTHERS = "PLAYER_OTHERS"
    
    /// all players
    static let PLAYER_ALL = "PLAYER_ALL"
    
    /// player after current turn
    static let PLAYER_NEXT = "PLAYER_NEXT"
    
    /// select any other player
    static let PLAYER_SELECT_ANY = "PLAYER_SELECT_ANY"
    
    /// select any reachable player
    static let PLAYER_SELECT_REACHABLE = "PLAYER_SELECT_REACHABLE"
    
    /// select any player at distance of 1
    static let PLAYER_SELECT_AT_1 = "PLAYER_SELECT_AT_1"
    
    /// previous effect's target
    static let PLAYER_TARGET = "PLAYER_TARGET"
}

extension Args {
    
    /// resolve player argument
    static func resolvePlayer<T: Effect>(
        _ player: String,
        copyWithPlayer: @escaping (String) -> T,
        ctx: [EffectKey: any Equatable],
        state: State 
    ) -> Result<EffectOutput, Error> {
        switch resolvePlayer(player, ctx: ctx, state: state) {
            
        case let .success(data):
            switch data {
            case let .identified(pIds):
                let effects = pIds.map { copyWithPlayer($0) }
                return .success(EffectOutput(effects: effects))
                
            case let .selectable(pIds):
                if let selectedId = ctx.stringForKey(.SELECTED),
                   pIds.contains(selectedId) {
                    let copy = copyWithPlayer(selectedId)
                    return .success(EffectOutput(effects: [copy]))
                } else {
                    let options = pIds.map { Choose(value: $0, actor: ctx.stringForKey(.ACTOR)!) }
                    return .success(EffectOutput(decisions: options))
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
    
    static func resolvePlayer(_ player: String, ctx: [EffectKey: any Equatable], state: State) -> Result<PlayerResolved, Error> {
        switch player {
        case .PLAYER_ACTOR:
            return .success(.identified([ctx.stringForKey(.ACTOR)!]))
            
        case .PLAYER_OTHERS:
            let others = Array(state.playOrder.starting(with: ctx.stringForKey(.ACTOR)!).dropFirst())
            return .success(.identified(others))
            
        case .PLAYER_ALL:
            let all = state.playOrder.starting(with: ctx.stringForKey(.ACTOR)!)
            return .success(.identified(all))
            
        case .PLAYER_NEXT:
            guard let turn = state.turn else {
                fatalError(.turnValueInvalid)
            }
            
            let next = state.playOrder.element(after: turn)
            return .success(.identified([next]))
            
        case .PLAYER_SELECT_ANY:
            let others = state.playOrder.filter { $0 != ctx.stringForKey(.ACTOR) }
            return .success(.selectable(others))
            
        case .PLAYER_SELECT_REACHABLE:
            let weapon = state.player(ctx.stringForKey(.ACTOR)!).weapon
            return resolvePlayerAtDistance(weapon, state: state, actor: ctx.stringForKey(.ACTOR)!)
            
        case .PLAYER_SELECT_AT_1:
            return resolvePlayerAtDistance(1, state: state, actor: ctx.stringForKey(.ACTOR)!)
            
        case .PLAYER_TARGET:
            guard let target = ctx.stringForKey(.TARGET) else {
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
