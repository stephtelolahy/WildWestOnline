//
//  EffectContext.swift
//
//
//  Created by Hugues Telolahy on 09/04/2023.
//

import InitMacro

/// Context data associated to an effect
@Init(defaults: ["target": nil])
public struct EffectContext: Codable, Equatable {
    /// Player triggering effect
    let actor: String

    /// Card triggering effect
    let card: String

    /// Targeted player from action triggering this effect
    /// Or Targeted player while resolving effect
    var target: String?
}
