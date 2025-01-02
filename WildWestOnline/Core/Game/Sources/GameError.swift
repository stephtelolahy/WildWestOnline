//
//  GameError.swift
//
//  Created by Hugues Telolahy on 27/10/2024.
//

public enum GameError: Error, Equatable, Codable {
    case insufficientDeck
    case insufficientDiscard
    case playerAlreadyMaxHealth(String)
    case noReq(Card.StateReq)
    case noTarget(Card.Selector.TargetGroup)
    case noChoosableTarget([Card.Selector.TargetCondition])
    case cardNotPlayable(String)
    case cardAlreadyInPlay(String)
}
