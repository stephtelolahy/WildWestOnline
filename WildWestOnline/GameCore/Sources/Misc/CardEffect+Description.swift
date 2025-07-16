//
//  CardEffect+Description.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/02/2025.
//

extension Card.Effect: CustomStringConvertible {
    public var descriptionription: String {
        [
            selectors.isNotEmpty ? ".." : nil,
            name.emoji,
            payload.target,
            payload.card,
            payload.selection,
            payload.amount != nil ? "x\(payload.amount ?? 1)" : nil,
            payload.cards?.isNotEmpty == true ? (payload.cards ?? []).joined(separator: ", ") : nil,
            payload.played.isNotEmpty ? "<< \(payload.played):\(payload.player)" : nil
        ]
            .compactMap { $0 }
            .joined(separator: " ")
    }
}

private extension Card.Effect.Name {
    var emoji: String {
        Self.dict[self] ?? "⚠️\(rawValue)"
    }

    static let dict: [Card.Effect.Name: String] = [
        .activate: "🟢",
        .preparePlay: "⚪️",
        .play: "🟠",
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
