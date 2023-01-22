//
//  InternalError.swift
//  
//
//  Created by Hugues Telolahy on 21/01/2023.
//

/// Fatal game error
enum InternalError: Error {
    case unexpected
    case missingActor
    case missingPlayer(String)
    case missingPlayerCard(String)
    case missingPlayedCard
}
