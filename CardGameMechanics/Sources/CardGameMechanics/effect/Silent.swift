//
//  Silent.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 04/06/2022.
//

import CardGameCore

public extension Args {
    
    /// do nothing about played card's effect
    static let choosePass = "CHOOSE_PASS"
}

/// prevents an effect from being applied to a player
public struct Silent: Effect {
    
    let type: String
    
    private let target: String
    
    public init(type: String, target: String = Args.playerActor) {
        assert(!type.isEmpty)
        assert(!target.isEmpty)
        
        self.type = type
        self.target = target
    }
    
    public func resolve(in state: State, ctx: PlayContext) -> Result<EffectOutput, Error> {
        guard Args.isPlayerResolved(target, state: state) else {
            return Args.resolvePlayer(target,
                                      copyWithPlayer: { [self] in Silent(type: type, target: $0) },
                                      state: state,
                                      ctx: ctx)
        }
        
        let filter: (Effect) -> Bool = { effect in
            if let silentable = effect as? Silentable,
               silentable.type == type,
               silentable.target == target {
                return true
            } else {
                return false
            }
        }
        
        return .success(EffectOutput(cancel: filter))
    }
}

/// An effect that can be countered by target player
protocol Silentable {
    
    var target: String { get }
    
    var type: String? { get }
    
    /// Return counter moves
    func silentOptions(state: State, selectedArg: String?) -> [Move]?
}

extension Silentable where Self: Effect {
    
    func silentOptions(state: State, selectedArg: String?) -> [Move]? {
        guard Args.isPlayerResolved(target, state: state),
              let effectType = type else {
            return nil
        }
        
        guard selectedArg != Args.choosePass else {
            return nil
        }
        
        let targetObj = state.player(target)
        let silentCards = targetObj.hand.filter { $0.onPlay.contains { ($0 as? Silent)?.type == effectType } }
        guard !silentCards.isEmpty else {
            return nil
        }
        
        var options: [Move] = silentCards.map { Play(card: $0.id, actor: target) }
        options.append(Choose(value: Args.choosePass, actor: target))
        
        return options
    }
}
