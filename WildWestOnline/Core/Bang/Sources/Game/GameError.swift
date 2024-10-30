//
//  GameError.swift
//  Bang
//
//  Created by Hugues Telolahy on 27/10/2024.
//

public enum GameError: Error, Equatable, Codable {
    case deckIsEmpty
    case discardIsEmpty
    case cardNotInDeck(String)
    case cardNotDiscovered(String)
    case playerAlreadyMaxHealth(String)
    case noReq(PlayReq)
}
