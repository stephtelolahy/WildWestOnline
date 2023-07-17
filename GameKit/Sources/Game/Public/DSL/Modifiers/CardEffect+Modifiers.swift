//
//  CardEffect+Modifiers.swift
//  
//
//  Created by Hugues Telolahy on 23/04/2023.
//

public extension CardEffect {
    func `repeat`(_ times: NumArg) -> Self {
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
    
    func triggered(_ eventReq: EventReq) -> CardAction {
        .init(eventReq: eventReq, effect: self, playReqs: [])
    }
    
    static func group(@CardEffectsBuilder content: () -> [Self]) -> Self {
        .group(content())
    }
}

public extension CardAction {
    func require(_ playReqs: PlayReq...) -> Self {
        .init(eventReq: eventReq, effect: effect, playReqs: playReqs)
    }
}
