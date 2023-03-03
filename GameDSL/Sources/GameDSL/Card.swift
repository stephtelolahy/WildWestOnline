//
//  Card.swift
//  
//
//  Created by Hugues Telolahy on 03/03/2023.
//

/// Cards that are used in a game.
/// Cards can have a cost, can have multiple properties, define additional rules,
/// have actions that can be played and have side effects that happen when they are being played.
public struct Card {

    /// Card unique identifier
    public let id: String

    /// Actions that can be performed with the card
    public let actions: [CardAction]

    /// All attributes
    let attr: [any Attribute]
}

/// Function defining card side effects
public struct CardAction {

    /// Side effect on dispatching action
    public let effect: Effect

    /// The manner an action is dispatched
    public let type: CardActionType

    /// requirements for playing this card
    public let requirements: [Requirement]
}

public enum CardActionType {

    /// card is active when your turn and requirments are met
    /// then you can choose to play it
    case active

    /// the side effects are applyed as soon as requirements are met
    case triggered
}

/// Function  defining constraints to play a card
public protocol Requirement {
    func match(_ ctx: Game) -> Result<Void, Error>
}

/// Function defining card side effect
public protocol Effect: Event {

    /// Resolving context
    var ctx: [any Attribute] { get set }
}
