//
//  GameAction+Describing.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 20/10/2024.
//
// swiftlint:disable force_unwrapping

extension GameAction: CustomStringConvertible {
    public var description: String {
        switch type {
        case .playBrown:
            "🟤 \(payload.actor) \(payload.card!)"

        default:
            fatalError()
        }

    }
}
