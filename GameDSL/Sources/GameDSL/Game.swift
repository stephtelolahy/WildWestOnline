import Foundation
import Combine

/// Trading card games state
/// It is turn based, cards have actions, cards have properties and cards have rules
public struct Game {
    
    /// All attributes
    public var attr: [any Attribute]
}

/// Any card, player, game attribute
/// Expected to be unique
public protocol Attribute {
    associatedtype Value
    
    /// attribute name
    var name: String { get }

    /// attribute value
    var value: Value { get }
}

/// Player who is participating in a game
public struct Player {
    
    /// player unique identifier
    public let id: String
    
    /// All attributes
    public var attr: [any Attribute]
}