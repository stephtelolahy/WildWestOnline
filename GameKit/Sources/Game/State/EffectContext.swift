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

    /// Root action which causes the effect to be cancelled automatically
    /// when this action got cancelled
    let cancellingAction: GameAction?

    /// Targeted player while resolving the effect
    var target: String?

    /// Chooser while resolving selectable card
    var chooser: String?

    public init(
        actor: String,
        card: String,
        event: GameAction,
        cancellingAction: GameAction? = nil,
        target: String? = nil,
        chooser: String? = nil
    ) {
        self.actor = actor
        self.card = card
        self.event = event
        self.cancellingAction = cancellingAction
        self.target = target
        self.chooser = chooser
    }
}
