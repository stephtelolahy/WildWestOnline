//
//  InternalError.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

public func fatalError(_ error: InternalError, file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError(String(describing: error), file: file, line: line)
}

/// Fatal game state error
public enum InternalError: Error {
    
    case missingPlayer(String)
    case missingPlayerCard(String)
    case missingStoreCard(String)
    case missingCardScript(String)
    case missingTarget
    case missingActor
    
    case invalidTurn
    case invalidCardSource
    case invalidError(String)   // Error type must impelment Event
    case invalidPlayer(String)
    case invalidCard(String)
    case invalidNumber(String)
}
