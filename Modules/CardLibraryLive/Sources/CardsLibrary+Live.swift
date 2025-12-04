//
//  CardLibrary+Live.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 03/12/2025.
//
import CardLibrary

public extension CardLibrary {
    static func live() -> Self {
        .init(
            cards: { Cards.all },
            deck: { Deck.all },
            specialSounds: { SFX.specialSounds }
        )
    }
}
