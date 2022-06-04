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
    
    /// resolve player argument
    static func resolvePlayer<T: Effect>(
        _ player: String,
        copyWithTarget: @escaping (String) -> T,
        ctx: State,
        cardRef: String
    ) -> Result<State, Error> {
        let actor = ctx.sequence(cardRef).actor
        switch resolvePlayer(player, ctx: ctx, actor: actor) {
        case let .success(pIds):
            let events = pIds.map { copyWithTarget($0) }
            var state = ctx
            var sequence = state.sequence(cardRef)
            sequence.queue.insert(contentsOf: events, at: 0)
            state.sequences[cardRef] = sequence
            return .success(state)
            
        case let .failure(error):
            return .failure(error)
        }
    }
    
    static func isPlayerResolved(_ player: String, ctx: State) -> Bool {
        ctx.players.contains { $0.key == player }
    }
    
    static func resolvePlayer(_ player: String, ctx: State, actor: String) -> Result<[String], Error> {
        switch player {
        case playerActor:
            return .success([actor])
            
        case playerOthers:
            let others = Array(ctx.playOrder.starting(with: actor).dropFirst())
            return .success(others)
            
        case playerAll:
            let all = ctx.playOrder.starting(with: actor)
            return .success(all)
            
        case playerNext:
            guard let turn = ctx.turn else {
                fatalError(.turnUndefined)
            }
            
            let next = ctx.playOrder.element(after: turn)
            return .success([next])
            
        default:
            guard ctx.players.contains(where: { $0.key == player }) else {
                fatalError(.playerValueInvalid(player))
            }
            
            return .success([player])
        }
    }
}
