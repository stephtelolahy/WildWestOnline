//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 31/05/2022.
//

func fatalError(_ error: InternalError, file: StaticString = #file, line: UInt = #line) -> Never {
    fatalError(String(describing: error), file: file, line: line)
}

/// Fatal game state error
enum InternalError: Error {
    case playerCardNotFound(String)
    case playerNotFound(String)
    case sequenceParentRefNotFound
    case sequenceNotFound(String)
    case storeMustNotBeEmpty
    case storeCardNotFound(String)
    case cardSourceMustBePlayer
    case turnUndefined
    case targetValueInvalid(String)
    case playerValueInvalid(String)
    case numberValueInvalid(String)
}
