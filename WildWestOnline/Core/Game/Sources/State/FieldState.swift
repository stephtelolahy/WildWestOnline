//
//  FieldState.swift
//  
//
//  Created by Stephano Hugues TELOLAHY on 29/06/2024.
//

public struct FieldState: Equatable, Codable {
    /// Deck
    public var deck: [String]

    /// Discard pile
    public var discard: [String]

    /// Discovered cards
    public var discovered: [String]

    /// Hand cards
    public var hand: [String: [String]]

    /// In play cards
    public var inPlay: [String: [String]]
}

public extension FieldState {
    enum Error: Swift.Error, Equatable {
        /// Already having same card in play
        case cardAlreadyInPlay(String)

        /// Expected non empty deck
        case deckIsEmpty

        /// Expected non empty discard pile
        case discardIsEmpty
    }
}
