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
            "✅ \(player) \(card)"

        case let .equip(card, player):
            "💼 \(player) \(card)"

        case let .handicap(card, target, player):
            "🚫 \(player) \(card) \(target)"

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

        case let .putBack(card, player):
            "❌ \(player) \(card)"

        case let .discardInPlay(card, player):
            "❌ \(player) \(card)"

        case let .discardPlayed(card, player: player):
            "❌ \(player) \(card)"

        case let .revealHand(card, player):
            "🎲 \(player) \(card)"

        case let .passInPlay(card, target, player):
            "🧨 \(player) \(target) \(card)"

        case .discover:
            "🎁"

        case .draw:
            "🎲"

        case let .startTurn(player):
            "🔥 \(player)"

        case let .endTurn(player):
            "💤 \(player)"

        case let .eliminate(player):
            "☠️ \(player)"

        case let .setAttribute(key, value, player):
            "😎 \(player) \(key) \(value)"

        case let .removeAttribute(key, player):
            "😕 \(player) \(key)"

        case let .setGameOver(winner):
            "🎉 \(winner)"

        case let .cancel(action):
            "✋ \(String(describing: action))"

        case let .chooseOne(_, options, player):
            "❓ \(player) \(options.joined(separator: " "))"

        case let .choose(option, player):
            "👉 \(player) \(option)"

        case let .activate(cards, player):
            "❔ \(player) \(cards.joined(separator: " "))"

        case let .effect(effect, _):
            "➡️ \(effect)"

        case let .group(actions):
            "➡️ group \(actions)"
        }
    }
}
