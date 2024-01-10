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
    let cancellingAction: GameAction?

    /// Targeted player while resolving the effect
    var target: String?

    /// Card chooser while resolving the effect
    var chooser: String?

    /// Chosen option while resolving effect
    var option: String?

    public init(
        actor: String,
        card: String,
        event: GameAction,
        cancellingAction: GameAction? = nil
    ) {
        self.actor = actor
        self.card = card
        self.event = event
        self.cancellingAction = cancellingAction
    }
}
