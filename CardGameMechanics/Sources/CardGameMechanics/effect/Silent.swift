//
//  Silent.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

import CardGameCore

/// prevents an effect of some `Type` from being applied to a `player`
///
public struct Silent: Effect {
    let type: String
    let player: String
    
    public init(type: String, player: String = Args.playerActor) {
        assert(!type.isEmpty)
        assert(!player.isEmpty)
        
        self.type = type
        self.player = player
    }
    
    public func resolve(in state: State, ctx: [String: String]) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(player, state: state) else {
            return Args.resolvePlayer(player,
                                      copyWithPlayer: { [self] in Silent(type: type, player: $0) },
                                      ctx: ctx,
                                      state: state)
        }
        
        let filter: (Effect) -> Bool = { effect in
            if let silentable = effect as? Silentable,
               silentable.type == type,
               silentable.player == player {
                return true
            } else {
                return false
            }
        }
        
        return .success(EffectOutput(cancel: filter))
    }
}

/// Describing an effect that can be countered by target player
///
protocol Silentable {
    var player: String { get }
    var type: String? { get }
    
    func counterMoves(state: State, ctx: [String: String]) -> [Move]?
}

extension Silentable where Self: Effect {
    
    func counterMoves(state: State, ctx: [String: String]) -> [Move]? {
        guard Args.isPlayerResolved(player, state: state),
              let effectType = type else {
            return nil
        }
        
        guard ctx[Args.selected] != Args.choosePass else {
            return nil
        }
        
        let playerObj = state.player(player)
        let silentCards = playerObj.hand.filter { $0.onPlay.contains { ($0 as? Silent)?.type == effectType } }
        guard !silentCards.isEmpty else {
            return nil
        }
        
        var moves: [Move] = silentCards.map { Play(card: $0.id, actor: player) }
        moves.append(Choose(value: Args.choosePass, actor: player))
        
        return moves
    }
}

public extension Args {
    /// do nothing about played card's effect
    static let choosePass = "CHOOSE_PASS"
}
