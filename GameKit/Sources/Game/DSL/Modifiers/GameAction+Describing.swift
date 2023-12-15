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
            "❇️ \(player) -> \(target) \(card)"

        case let .playImmediate(card, target, player):
            if let target {
                "❇️ \(player) -> \(target) \(card)"
            } else {
                "✅ \(player) \(card)"
            }

        case let .playAs(alias, _, target, player):
            if let target {
                "❇️ \(player) -> \(target) \(alias)"
            } else {
                "✅ \(player) \(alias)"
            }

        case let .heal(amount, player):
            "\(String(repeating: "❤️", count: amount)) \(player)"

        case let .damage(amount, player):
            "\(String(repeating: "🥵", count: amount)) \(player)"

        case let .drawDeck(player):
            "💰 \(player)"

        case let .drawDiscard(player):
            "💰 \(player)"

        case let .drawArena(card, player):
            "💰 \(player) \(card)"

        case let .drawHand(card, target, player):
            "‼️ \(player) -> \(target) \(card)"

        case let .drawInPlay(card, target, player):
            "‼️ \(player) -> \(target) \(card)"

        case let .discardHand(card, player):
            "❌ \(player) \(card)"

        case let .discardInPlay(card, player):
            "❌ \(player) \(card)"

        case let .revealHand(card, player):
            "🎲 \(player) \(card)"

        case let .passInPlay(card, target, player):
            "🧨 \(player) -> \(target) \(card)"

        case .discover:
            "🌁 >"

        case .putBack:
            "🌁 <"

        case .draw:
            "🎲"

        default:
            ""
        }
    }
}
