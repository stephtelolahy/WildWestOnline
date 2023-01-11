//
//  InternalError.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//

func fatalError(_ error: InternalError, file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError(String(describing: error), file: file, line: line)
}

/// Fatal game state error
public enum InternalError: Error {
    
    case missingPlayer(String)
    case missingActor
    case missingPlayerCard(String)
    case missingCardScript(String)
    case missingStoreCard(String)
    case missingTurn
    case missingCardOwner
}
