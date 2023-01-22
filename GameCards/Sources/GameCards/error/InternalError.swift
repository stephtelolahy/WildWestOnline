//
//  InternalError.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

/// Fatal game errors
enum InternalError: Error {
    case missingTarget
    case missingPlayerCard(String)
    case missingPlayerHandCard(String)
    case missingCardScript(String)
    case missingStoreCard(String)
    case missingTurn
    case missingNext
    case missingCardOwner
    case missingCardValue
    case unexpected
}
