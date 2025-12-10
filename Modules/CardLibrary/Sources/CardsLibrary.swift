//
//  CardLibrary.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//
import AudioClient
import GameCore

public struct CardLibrary {
    public var cards: () -> [Card]
    public var deck: () -> [String]
    public var specialSounds: () -> [Card.ActionName: [String: AudioClient.Sound]]

    public init(
        cards: @escaping () -> [Card],
        deck: @escaping () -> [String],
        specialSounds: @escaping () -> [Card.ActionName: [String: AudioClient.Sound]]
    ) {
        self.cards = cards
        self.deck = deck
        self.specialSounds = specialSounds
    }
}
