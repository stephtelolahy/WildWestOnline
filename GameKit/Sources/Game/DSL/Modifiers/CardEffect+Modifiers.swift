//
//  CardEffect+Modifiers.swift
//
//
//  Created by Hugues Telolahy on 23/04/2023.
//

public extension CardEffect {

    static func group(@CardEffectsBuilder content: () -> [Self]) -> Self {
        .group(content())
    }

    func `repeat`(_ times: ArgNum) -> Self {
        .repeat(times, effect: self)
    }

    func `repeat`(_ times: Int) -> Self {
        .repeat(.exact(times), effect: self)
    }

    func target(_ target: ArgPlayer) -> Self {
        .target(target, effect: self)
    }

    func force(otherwise: Self) -> Self {
        .force(self, otherwise: otherwise)
    }

    func challenge(_ challenger: ArgPlayer, otherwise: Self) -> Self {
        .challenge(challenger, effect: self, otherwise: otherwise)
    }

    func ignoreError() -> Self {
        .ignoreError(self)
    }

    func on(_ playReqs: [PlayReq]) -> CardRule {
        .init(effect: self, playReqs: playReqs)
    }
}
