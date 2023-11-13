//
//  EffectContext+Player.swift
//
//
//  Created by Hugues Telolahy on 13/11/2023.
//

extension EffectContext {

    /// Player to whom effect is applied
    func player() -> String {
        target ?? actor
    }
}
