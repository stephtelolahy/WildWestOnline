//
//  GameArea.swift
//  WildWestOnline
//
//  Created by Hugues Stéphano TELOLAHY on 05/12/2025.
//

enum GameArea: Hashable {
    case deck
    case discard
    case discovered
    case playerHand(String)
    case playerInPlay(String)
}
