//
//  Cards.swift
//
//  Created by Hugues Telolahy on 28/10/2024.
//
// swiftlint:disable file_length line_length
import GameCore

/// BANG! THE BULLET
/// https://bang.dvgiochi.com/cardslist.php?id=2#q_result
public enum Cards {
    public static let all: [String: Card] = (
        Collectibles.all
        + Figures.all
        + PlayerAbilities.all
        )
        .reduce(into: [:]) { result, card in
            result[card.name] = card
        }
}
