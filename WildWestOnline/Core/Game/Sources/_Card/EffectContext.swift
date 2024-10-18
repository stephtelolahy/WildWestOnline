//
//  EffectContext.swift
//  WildWestOnline
//
//  Created by Hugues Stephano TELOLAHY on 27/09/2024.
//

/// Context data associated to an effect
@available(*, deprecated, message: "use PendingAction")
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
}
