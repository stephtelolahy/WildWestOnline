//
//  GameAction+Describing.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 14/12/2023.
//

extension GameAction: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .preparePlay(card, player):
            "✅ \(player) \(card)"

        case let .playBrown(card, player):
            "✅ \(player) \(card)"

        case let .playAbility(card, player):
            "✅ \(player) \(card)"

        case let .playEquipment(card, player):
            "💼 \(player) \(card)"

        case let .playHandicap(card, target, player):
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

        case let .stealHand(card, target, player):
            "‼️ \(player) \(card) \(target)"

        case let .stealInPlay(card, target, player):
            "‼️ \(player) \(card) \(target)"

        case let .discardHand(card, player):
            "❌ \(player) \(card)"

        case let .putBack(card, player):
            "❌ \(player) \(card)"

        case let .discardInPlay(card, player):
            "❌ \(player) \(card)"

        case let .playBrown(card, player: player):
            "❌ \(player) \(card)"

        case let .showHand(card, player):
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

        case let .endGame(winner):
            "🎉 \(winner)"

        case let .chooseOne(_, options, player):
            "❓ \(player) \(options.joined(separator: " "))"

        case let .prepareChoose(option, player):
            "👉 \(player) \(option)"

        case let .activate(cards, player):
            "❔ \(player) \(cards.joined(separator: " "))"

        case let .prepareEffect(effect, _):
            "➡️ \(effect)"

        case let .group(actions):
            "➡️ group \(actions)"

        default:
            fatalError("unexpected")
        }
    }
}
