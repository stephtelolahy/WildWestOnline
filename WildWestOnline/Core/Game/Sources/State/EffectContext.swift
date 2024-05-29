//
//  EffectContext.swift
//
//
//  Created by Hugues Telolahy on 09/04/2023.
//

/// Context data associated to an effect
public struct EffectContext: Codable, Equatable {
    /// Occurred event triggering the effect
    let sourceEvent: GameAction

    /// Owner of the card triggering the effect
    let sourceActor: String

    /// Card triggering the effect
    let sourceCard: String

    /// Targeted player while resolving the effect
    var resolvingTarget: String?

    /// Chooser player while resolving the effect
    var resolvingChooser: String?

    /// Chosen option while resolving effect
    var resolvingOption: String?

    /// Effect is linked to shoot on a given player, 
    /// The cancelation of the shoot results in the cancelation of the effect
    var linkedToShoot: String?
}
