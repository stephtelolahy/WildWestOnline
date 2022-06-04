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
    case sequenceNotFound(String)
    case storeMustNotBeEmpty
    case storeCardNotFound(String)
    case cardSourceMustBePlayer
    case turnUndefined
    case targetValueInvalid(String)
    case playerValueInvalid(String)
    case numberValueInvalid(String)
    case errorMustBeAnEvent(String)
}
