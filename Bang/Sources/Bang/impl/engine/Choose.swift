//
//  Choose.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

/// Select an option during effect resolution
public struct Choose: Move, Equatable {
    public let actor: String
    private let label: String
    @EquatableIgnore var children: [Event]?
    
    public init(actor: String, label: String, children: [Event]? = nil) {
        self.actor = actor
        self.label = label
        self.children = children
    }
    
    public func resolve(_ ctx: Game) -> Result<EventOutput, GameError> {
        /// emit state changes even if no changes occurred
        /// to mark that effect was successfully resolved
        .success(EventOutputImpl(state: ctx, children: children))
    }
    
    public func isValid(_ ctx: Game) -> Result<Void, GameError> {
        fatalError(.unexpected)
    }
}

extension Choose: CustomStringConvertible {
    public var description: String {
        "Choose(actor: \(actor), label: \(label))"
    }
}

public enum Label {
    /// Random hand card label
    /// displayed when choosing random hand card
    public static let randomHand = "randomHand"
    
    /// Choose to pass when asked to do an action
    public static let pass = "pass"
}
