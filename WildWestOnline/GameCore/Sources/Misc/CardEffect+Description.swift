//
//  CardEffect+Description.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/02/2025.
//

extension Card.Effect: CustomStringConvertible {
    public var description: String {
        [
            selectors.isNotEmpty ? ".." : nil,
            name.emoji,
            payload.targetedPlayer,
            payload.targetedCard,
            payload.chosenOption,
            payload.amount != nil ? "x\(payload.amount ?? 1)" : nil,
            payload.affectedCards?.isNotEmpty == true ? (payload.affectedCards ?? []).joined(separator: ", ") : nil,
            payload.playedCard.isNotEmpty ? "<< \(payload.playedCard):\(payload.player)" : nil
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
