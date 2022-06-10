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
    
    case playerCardNotFound(String)
    case playerNotFound(String)
    case storeCardNotFound(String)
    case cardScriptNotFound(String)
    
    case turnValueInvalid
    case cardSourceInvalid
    case errorTypeInvalid(String)
    case playerValueInvalid(String)
    case cardValueInvalid(String)
    case numberValueInvalid(String)
}
