//
//  GameAction+Describing.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 14/12/2023.
//

extension GameAction: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .play(card, player):
            "▶️ \(player) \(card)"

        case let .playEquipment(card, player):
            "✅ \(player) \(card)"

        case let .playHandicap(card, target, player):
            "❇️ \(player) \(card) \(target)"

        case let .playImmediate(card, target, player):
            if let target {
                "❇️ \(player) \(card) \(target)"
            } else {
                "✅ \(player) \(card)"
            }

        case let .playAs(alias, _, target, player):
            if let target {
                "❇️ \(player) \(alias) \(target)"
            } else {
                "✅ \(player) \(alias)"
            }

        default:
            ""
        }
    }
}
