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
    static let targetAny = "TARGET_ANY"
    
    /// select any reachable player
    static let targetReachable = "TARGET_REACHABLE"
    
    /// resolve player argument
    static func resolvePlayer<T: Effect>(
        _ player: String,
        copyWithTarget: @escaping (String) -> T,
        ctx: State,
        cardRef: String
    ) -> Result<State, Error> {
        let actor = ctx.sequence(cardRef).actor
        switch resolvePlayer(player, ctx: ctx, actor: actor) {
            
        case let .success(data):
            switch data {
            case let .identified(pIds):
                let events = pIds.map { copyWithTarget($0) }
                var state = ctx
                var sequence = state.sequence(cardRef)
                sequence.queue.insert(contentsOf: events, at: 0)
                state.sequences[cardRef] = sequence
                
                return .success(state)
                
            case let .selectable(pIds):
                var state = ctx
                var sequence = ctx.sequence(cardRef)
                let key = "\(actor)-target"
                
                // pick and remove selection
                if let selectedId = sequence.selectedArgs[key] {
                    sequence.selectedArgs.removeValue(forKey: key)
                    let copy = copyWithTarget(selectedId)
                    sequence.queue.insert(copy, at: 0)
                    state.sequences[cardRef] = sequence
                    
                    return .success(state)
                }
                
                // set choose target decision
                let actions = pIds.map { Choose(value: $0, key: key, actor: actor) }
                state.decisions[actor] = Decision(options: actions, cardRef: cardRef)
                let originalEffect = copyWithTarget(player)
                sequence.queue.insert(originalEffect, at: 0)
                state.sequences[cardRef] = sequence
                
                return .success(state)
            }
            
        case let .failure(error):
            return .failure(error)
        }
    }
    
    static func isPlayerResolved(_ player: String, ctx: State) -> Bool {
        ctx.players.contains { $0.key == player }
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
            
        case targetAny:
            let others = ctx.playOrder.filter { $0 != actor }
            return .success(.selectable(others))
            
        case targetReachable:
            let weapon = ctx.player(actor).weapon
            let players = ctx.playersAt(weapon, actor: actor)
            guard !players.isEmpty else {
                return .failure(ErrorNoPlayersAtRange(distance: weapon))
            }
            
            return .success(.selectable(players))
            
        default:
            /// assume identified player
            guard ctx.players.contains(where: { $0.key == player }) else {
                fatalError(.playerValueInvalid(player))
            }
            
            return .success(.identified([player]))
        }
    }
    
    enum PlayerResolved {
        case identified([String])
        case selectable([String])
    }
}
