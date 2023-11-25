//
//  GameError.swift
//  
//
//  Created by Hugues Telolahy on 07/04/2023.
//

/// Renderable game errors
public enum GameError: Error, Codable, Equatable {
    // MARK: - Specific error

    /// Expected player to be damaged
    case playerAlreadyMaxHealth(String)

    /// Expected a card with given identifier
    case cardNotFound(String)

    /// Expected card to have play rule
    case cardNotPlayable(String)

    /// Expected non empty deck
    case deckIsEmpty

    /// Expected non empty discard pile
    case discardIsEmpty

    /// Expected to choose one of waited action
    case unwaitedAction

    /// Expected game to be active
    case gameIsOver

    /// Already having same card in play
    case cardAlreadyInPlay(String)

    // MARK: - Matching error

    /// Not matching card
    case noCard(ArgCard)

    /// Not matching player
    case noPlayer(ArgPlayer)

    /// Not matching requirement
    case noReq(PlayReq)

    /// No valid chooseOne option
    case noValidOption

    /// No shoot effect to counter
    case noShootToCounter
}
