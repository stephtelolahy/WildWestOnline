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
    
    public init(type: String, player: String = .PLAYER_ACTOR) {
        assert(!type.isEmpty)
        assert(!player.isEmpty)
        
        self.type = type
        self.player = player
    }
    
    public func resolve(in state: State, ctx: [EffectKey: any Equatable]) -> Result<EffectOutput, Error> {
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
    
    func counterMoves(state: State, ctx: [EffectKey: any Equatable]) -> [Move]?
}

extension Silentable where Self: Effect {
    
    func counterMoves(state: State, ctx: [EffectKey: any Equatable]) -> [Move]? {
        guard Args.isPlayerResolved(player, state: state),
              let effectType = type else {
            return nil
        }
        
        if ctx.stringForKey(.SELECTED) == .CHOOSE_PASS {
            return nil
        }
        
        let playerObj = state.player(player)
        let silentCards = playerObj.hand.filter { $0.onPlay.contains { ($0 as? Silent)?.type == effectType } }
        guard !silentCards.isEmpty else {
            return nil
        }
        
        var moves: [Move] = silentCards.map { Play(card: $0.id, actor: player) }
        moves.append(Choose(value: .CHOOSE_PASS, actor: player))
        
        return moves
    }
}
