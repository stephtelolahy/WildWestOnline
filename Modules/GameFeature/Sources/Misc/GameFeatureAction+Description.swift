//
//  GameFeatureAction+Description.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 23/02/2025.
//

extension GameFeature.Action: CustomStringConvertible {
    public var description: String {
        [
            selectors.isEmpty ? name.emoji : "..",
            name.rawValue,
            targetedPlayer,
            targetedCard,
            chosenOption,
            amount != nil ? "x\(amount ?? 0)" : nil,
            affectedCards?.isNotEmpty == true ? (affectedCards ?? []).joined(separator: ", ") : nil,
            playedCard.isNotEmpty ? "<< \(playedCard):\(sourcePlayer)" : nil
        ]
            .compactMap { $0 }
            .joined(separator: " ")
    }
}

private extension Card.EffectName {
    var emoji: String {
        Self.dict[self] ?? ""
    }

    static let dict: [Card.EffectName: String] = [
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
