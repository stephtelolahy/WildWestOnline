//
//  Silent.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

/// prevents an effect of some `Type` from being applied to a `player`
///
public struct Silent: Effect, Equatable {
    let type: String
    let player: String
    
    @EquatableNoop
    public var ctx: [ContextKey: Any]
    
    public init(type: String, player: String = .PLAYER_ACTOR, ctx: [ContextKey: Any] = [:]) {
        assert(!type.isEmpty)
        assert(!player.isEmpty)
        
        self.type = type
        self.player = player
        self.ctx = ctx
    }
    
    public func resolve(in state: State) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(player, state: state) else {
            return Args.resolvePlayer(player,
                                      copy: { Silent(type: type, player: $0, ctx: ctx) },
                                      ctx: ctx,
                                      state: state)
        }
        
        let filter: (Effect) -> Bool = { [self] effect in
            if let silentable = effect as? Silentable,
               silentable.type == type,
               silentable.player == player {
                return true
            } else {
                return false
            }
        }
        
        return .success(EffectOutput(cancel: (filter, ErrorNoEffectToSilent())))
    }
}

/// Describing an effect that can be countered by target player
///
protocol Silentable {
    var player: String { get }
    var type: String? { get }
    
    /// Possible reaction options
    func reactionMoves(in state: State) -> [Move]?
}

extension Silentable where Self: Effect {
    
    func reactionMoves(in state: State) -> [Move]? {
        guard Args.isPlayerResolved(player, state: state),
              let effectType = type else {
            return nil
        }
        
        if ctx.booleanForKey(.PASS) == true {
            return nil
        }
        
        let playerObj = state.player(player)
        let silentCards = playerObj.hand.filter { $0.onPlay.contains { ($0 as? Silent)?.type == effectType } }
        guard !silentCards.isEmpty else {
            return nil
        }
        
        var options: [Move] = silentCards.map { Play(card: $0.id, actor: player) }
        var pass = self
        pass.ctx[.PASS] = true
        options.append(Choose(value: nil, actor: player, effects: [pass]))
        return options
    }
}
