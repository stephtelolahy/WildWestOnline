//
//  EffectContext.swift
//
//
//  Created by Hugues Telolahy on 09/04/2023.
//

import InitMacro

/// Context data associated to an effect
@Init(defaults: ["target": nil, "cancellingAction": nil, "chooserId": nil])
public struct EffectContext: Codable, Equatable {
    /// Owner of the card triggering the effect
    let actor: String

    /// Card triggering the effect
    let card: String

    /// Occurred event triggering the effect
    let event: GameAction

    /// Targeted player while resolving the effect
    var target: String?

    /// Root action which causes the effect to be cancelled automatically
    /// when this action got cancelled
    let cancellingAction: GameAction?

    /// Chooser while resolving selectable  card
    var chooserId: String?
}
