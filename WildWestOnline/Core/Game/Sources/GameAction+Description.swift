//
//  GameAction+Description.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/02/2025.
//

extension GameAction: CustomStringConvertible {
    public var description: String {
        [
            payload.selectors.isNotEmpty ? ".." : nil,
            kind.emoji,
            payload.target,
            payload.card,
            payload.selection,
            payload.amount != nil ? "x\(payload.amount ?? 1)" : nil,
            payload.cards.isNotEmpty ? payload.cards.joined(separator: ", ") : nil,
            payload.source.isNotEmpty ? "<< \(payload.source):\(payload.actor)" : nil
        ]
            .compactMap { $0 }
            .joined(separator: " ")
    }
}

private extension GameAction.Kind {
    var emoji: String {
        Self.dict[self] ?? "⚠️\(rawValue)"
    }

    static let dict: [GameAction.Kind: String] = [
        .activate: "🟢",
        .play: "⚪️",
        .discardPlayed: "🟠",
        .equip: "🔵",
        .handicap: "⚫️",
        .heal: "❤️",
        .damage: "🥵",
        .drawDeck: "💰",
        .drawDiscard: "💰",
        .drawDiscovered: "💰",
        .stealHand: "‼️",
        .stealInPlay: "‼️",
        .discardHand: "❌",
        .discardInPlay: "❌",
        .passInPlay: "💣",
        .draw: "🎲",
        .discover: "🎁",
        .shoot: "🔫",
        .startTurn: "🔥",
        .endTurn: "💤",
        .eliminate: "☠️",
        .endGame: "🎉",
        .choose: "👉",
        .queue: "➕",
        .setWeapon: "🎯",
        .increaseMagnifying: "🔎",
        .increaseRemoteness: "🐎"
    ]
}
