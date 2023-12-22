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
            "\n▶️ \(player) \(card)"

        case let .playEquipment(card, player):
            "✅ \(player) \(card)"

        case let .playAbility(card, player):
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
            "‼️ \(player) \(card) \(target)"

        case let .drawInPlay(card, target, player):
            "‼️ \(player) \(card) \(target)"

        case let .discardHand(card, player):
            "❌ \(player) \(card)"

        case let .putBackHand(card, player):
            "❌ \(player) \(card)"

        case let .discardInPlay(card, player):
            "❌ \(player) \(card)"

        case let .revealHand(card, player):
            "🎲 \(player) \(card)"

        case let .passInPlay(card, target, player):
            "🧨 \(player) -> \(target) \(card)"

        case .discover:
            "🎁"

        case .draw:
            "🎲"

        case let .setTurn(player):
            "🔥 \(player)"

        case let .eliminate(player):
            "☠️ \(player)"

        case let .setAttribute(key, value, player):
            "😎 \(player) \(key.rawValue) \(value)"

        case let .removeAttribute(key, player):
            "😕 \(player) \(key.rawValue) X"

        case let .setGameOver(winner):
            "🎉 \(winner)"

        case let .cancel(action):
            "✋ \(String(describing: action))"

        case let .chooseOne(options, player):
            "❓ \(player) \(Array(options.keys).joined(separator: " "))"

        case let .activate(cards, player):
            "❔ \(player) \(cards.joined(separator: " "))"

        case let .effect(effect, ctx):
            "➡️ \(ctx.actor) \(effect)"

        case let .group(actions):
            "➡️ group \(actions)"
        }
    }
}
