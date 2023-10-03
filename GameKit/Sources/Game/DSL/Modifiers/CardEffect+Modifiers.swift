//
//  CardEffect+Modifiers.swift
//  
//
//  Created by Hugues Telolahy on 23/04/2023.
//

public extension CardEffect {
    func `repeat`(_ times: ArgNum) -> Self {
        .repeat(times, effect: self)
    }
    
    func `repeat`(_ times: Int) -> Self {
        .repeat(.exact(times), effect: self)
    }
    
    func target(_ target: PlayerArg) -> Self {
        .target(target, effect: self)
    }

    func otherwise(_ effect: Self) -> Self {
        .force(self, otherwise: effect)
    }

    func challenge(_ challenger: PlayerArg, otherwise: Self) -> Self {
        .challenge(challenger, effect: self, otherwise: otherwise)
    }
    
    func when(_ playReqs: PlayReq...) -> CardRule {
        .init(playReqs: playReqs, effect: self)
    }
    
    static func group(@CardEffectsBuilder content: () -> [Self]) -> Self {
        .group(content())
    }
}
