import Foundation
import Combine

/// Game engine
public protocol Engine {
    
    /// observable game state
    var state: CurrentValueSubject<Game, Never> { get }
    
    /// events queue that have to be resolved in order
    var queue: [Event] { get }
    
    /// input a move
    func input(_ move: Event)
    
    /// process event queue
    func update()
}

/// Trading card games state
/// It is turn based, cards have actions, cards have properties and cards have rules
public struct Game {
    
    /// All attributes
    var attr: [Attribute]
}

/// Any card, player, game attribute
/// Expected to be unique
public protocol Attribute {
    
    /// attribute name
    var name: String { get }
}

/// Player who is participating in a game
public struct Player {
    
    /// player unique identifier
    public let id: String
    
    /// All attributes
    var attr: [Attribute]
}

/// Cards that are used in a game.
/// Cards can have a cost, can have multiple properties, define additional rules,
/// have actions that can be played and have side effects that happen when they are being played.
public struct Card {
    
    /// Card unique identifier
    public let id: String
    
    /// Actions that can be performed with the card
    public let actions: [CardAction]
    
    /// All attributes
    let attr: [Attribute]
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
    var ctx: [Attribute] { get set }
}

/// Function that causes any change in the game state
public protocol Event {
    func resolve(_ ctx: Game) -> Result<EventOutput, Error>
}

/// Resolving an event may update game or push another event
public struct EventOutput {
    
    /// Updated state
    public let state: Game?
    
    /// Children to be queued for resolving
    public let children: [Event]?
}
