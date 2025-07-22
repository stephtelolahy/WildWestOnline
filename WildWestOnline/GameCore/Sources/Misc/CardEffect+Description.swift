//
//  CardEffect+Description.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/02/2025.
//

extension Card.Effect: CustomStringConvertible {
    public var description: String {
        [
            selectors.isEmpty ? name.emoji : "..",
            name.rawValue,
            targetedPlayer,
            targetedCard,
            chosenOption,
            amount != nil ? "x\(amount ?? 0)" : nil,
            affectedCards?.isNotEmpty == true ? (affectedCards ?? []).joined(separator: ", ") : nil,
            playedCard != nil ? "<< \(playedCard ?? ""):\(sourcePlayer ?? "")" : nil
        ]
            .compactMap { $0 }
            .joined(separator: " ")
    }
}

private extension Card.Effect.Name {
    var emoji: String {
        Self.dict[self] ?? ""
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
