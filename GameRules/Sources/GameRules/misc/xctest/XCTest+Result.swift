//
//  XCTest+Result.swift
//  
//
//  Created by Hugues Telolahy on 09/01/2023.
//

import XCTest

public extension XCTestCase {
    
    func assertIsSuccess<T, E: Error>(
        _ result: Result<T, E>,
        then assertions: (T) throws -> Void = { _ in },
        message: (E) -> String = { "Expected to be a success but got a failure with \($0) " },
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
    
    func assertIsFailure<T, E: Error>(
        _ result: Result<T, E>,
        then assertions: (E) throws -> Void = { _ in },
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
    
    func assertIsFailure<T, E: Error & Equatable>(
        _ result: Result<T, E>,
        equalTo anError: E,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        assertIsFailure(result) {
            XCTAssertEqual($0, anError, file: file, line: line)
        }
    }
}
