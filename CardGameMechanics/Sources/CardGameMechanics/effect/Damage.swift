//
//  Damage.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//
import CardGameCore

/// deals damage to a character, attempting to reduce its Health by the stated amount
public struct Damage: Effect, Silentable {
    
    private let value: Int
    
    let target: String
    
    let type: String?
    
    public init(value: Int, target: String = Args.playerActor, type: String? = nil) {
        assert(value > 0)
        assert(!target.isEmpty)
        
        self.value = value
        self.target = target
        self.type = type
    }
    
    public func resolve(state: State, ctx: PlayContext) -> EffectResult {
        if let options = silentOptions(state: state, selectedArg: ctx.selectedArg) {
            return .suspended([target: options])
        }
        
        guard Args.isPlayerResolved(target, state: state) else {
            return Args.resolvePlayer(target,
                                      copyWithPlayer: { [self] in Damage(value: value, target: $0, type: type) },
                                      state: state,
                                      ctx: ctx)
        }
        
        var state = state
        var player = state.player(target)
        player.health -= value
        state.players[target] = player
        
        return .success(state)
    }
}
