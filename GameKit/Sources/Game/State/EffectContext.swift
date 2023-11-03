//
//  EffectContext.swift
//
//
//  Created by Hugues Telolahy on 09/04/2023.
//

import InitMacro

/// Context data associated to an effect
@Init(defaults: ["target": nil, "linkedAction": nil])
public struct EffectContext: Codable, Equatable {
    /// Player triggering effect
    let actor: String

    /// Card triggering effect
    let card: String

    /// Targeted player while resolving effect
    var target: String?

    /// Root action which causes the effect to be cancelled automatically
    /// when the root action got cancelled
    let rootAction: GameAction?
}
