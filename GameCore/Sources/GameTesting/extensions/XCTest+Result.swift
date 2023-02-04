//
//  XCTest+Result.swift
//  
//
//  Created by Hugues Telolahy on 09/01/2023.
//

import XCTest

public extension XCTestCase {
    
    func assertIsSuccess<T>(
        _ result: Result<T, Error>,
        then assertions: (T) throws -> Void = { _ in },
        message: (Error) -> String = { "Expected to be a success but got a failure with \($0) " },
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        switch result {
        case .failure(let error):
            XCTFail(message(error), file: file, line: line)
            
        case .success(let value):
            XCTAssertNoThrow(try assertions(value), file: file, line: line)
        }
    }
    
    func assertIsFailure<T>(
        _ result: Result<T, Error>,
        then assertions: (Error) throws -> Void = { _ in },
        message: (T) -> String = { "Expected to be a failure but got a success with \($0) " },
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        switch result {
        case .failure(let error):
            XCTAssertNoThrow(try assertions(error), file: file, line: line)
            
        case .success(let value):
            XCTFail(message(value), file: file, line: line)
        }
    }
}
