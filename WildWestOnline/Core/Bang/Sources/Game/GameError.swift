//
//  GameError.swift
//  Bang
//
//  Created by Hugues Telolahy on 27/10/2024.
//

public enum GameError: Error, Equatable, Codable {
    case insufficientDeck
    case insufficientDiscard
    case playerAlreadyMaxHealth(String)
    case noReq(StateCondition)
    case noTarget(ActionSelector.TargetGroup)
    case noChoosableTarget([ActionSelector.TargetCondition])
    case cardNotPlayable(String)
}
