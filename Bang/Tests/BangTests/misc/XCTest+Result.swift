//
//  XCTest+Result.swift
//  
//
//  Created by Hugues Telolahy on 09/01/2023.
//

import XCTest

extension XCTestCase {
    
    func assertIsSuccess<T, E>(
        _ result: Result<T, E>,
        then assertions: (T) throws -> Void = { _ in },
        message: (E) -> String = { "Expected to be a success but got a failure with \($0) "},
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws where E: Error {
        switch result {
        case .failure(let error):
            XCTFail(message(error), file: file, line: line)
        case .success(let value):
            try assertions(value)
        }
    }
    
    func assertIsFailure<T, E>(
        _ result: Result<T, E>,
        then assertions: (E) throws -> Void = { _ in },
        message: (T) -> String = { "Expected to be a failure but got a success with \($0) "},
        file: StaticString = #filePath,
        line: UInt = #line
    ) throws where E: Error {
        switch result {
        case .failure(let error):
            try assertions(error)
        case .success(let value):
            XCTFail(message(value), file: file, line: line)
        }
    }
}
