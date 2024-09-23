//
//  GameAction+Describing.swift
//  
//
//  Created by Hugues Stephano TELOLAHY on 14/12/2023.
//

extension GameAction: CustomStringConvertible {
    public var description: String {
        switch self {
        case let .playBrown(card, player):
            "🟤 \(player) \(card)"

        case let .playAbility(card, player):
            "🟡 \(player) \(card)"

        case let .playEquipment(card, player):
            "🔵 \(player) \(card)"

        case let .playHandicap(card, target, player):
            "🟣 \(player) \(card) \(target)"

        case let .heal(amount, player):
            "\(String(repeating: "❤️", count: amount)) \(player)"

        case let .damage(amount, player):
            "\(String(repeating: "🥵", count: amount)) \(player)"

        case let .drawDeck(player):
            "💰 \(player)"

        case let .drawDiscovered(card, player):
            "💰 \(player) \(card)"

        case let .drawDiscard(player):
            "💰 \(player)"

        case let .stealHand(card, target, player):
            "‼️ \(player) \(card) \(target)"

        case let .stealInPlay(card, target, player):
            "‼️ \(player) \(card) \(target)"

        case let .discardHand(card, player):
            "❌ \(player) \(card)"

        case let .discardInPlay(card, player):
            "❌ \(player) \(card)"

        case let .showLastHand(player):
            "🎲 \(player)"

        case let .passInPlay(card, target, player):
            "🧨 \(player) \(target) \(card)"

        case let .discover(amount):
            "🎁 \(amount)"

        case .draw:
            "🎲"

        case let .startTurn(player):
            "🔥 \(player)"

        case let .endTurn(player):
            "💤 \(player)"

        case let .eliminate(player):
            "☠️ \(player)"

        case let .setAttribute(key, value, player):
            "😎 \(player) \(key) \(value?.description ?? "/")"

        case let .endGame(winner):
            "🎉 \(winner)"

        case let .chooseOne(_, options, player):
            "❓ \(player) \(options.joined(separator: " "))"

        case let .activate(cards, player):
            "❔ \(player) \(cards.joined(separator: " "))"

        case let .preparePlay(card, player):
            "➡️ \(player) \(card) ..."

        case let .prepareChoose(option, player):
            "➡️ \(player) \(option) ..."

        case let .prepareEffect(effect):
            "➡️ \(effect.actor) \(effect.action.rawValue) ..."

        case let .queue(actions):
            "➡️ \(actions) ..."

        default:
            fatalError("unexpected")
        }
    }
}
