//
//  CardEffect+isResolved.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 28/03/2025.
//

public extension Card.Effect {
    var isResolved: Bool {
        guard selectors.isEmpty else {
            return false
        }

        switch name {
        case .queue, .preparePlay:
            return false

        default:
            return true
        }
    }
}
