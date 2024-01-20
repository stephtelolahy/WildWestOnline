//
//  EffectContext.swift
//
//
//  Created by Hugues Telolahy on 09/04/2023.
//

/// Context data associated to an effect
public struct EffectContext: Codable, Equatable {
    /// Owner of the card triggering the effect
    let actor: String

    /// Card triggering the effect
    let card: String

    /// Occurred event triggering the effect
    let event: GameAction

    /// When this action is cancelled
    /// then the effect is also cancelled automatically
    var cancellingAction: GameAction?

    /// Targeted player while resolving the effect
    var target: String?

    /// Card chooser while resolving the effect
    var cardChooser: String?

    /// Chosen option while resolving effect
    var chosenOption: String?
}
