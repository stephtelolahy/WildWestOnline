//
//  XCTest+Error.swift
//  
//
//  Created by Hugues Telolahy on 21/01/2023.
//

import XCTest

extension XCTestCase {
    
    func assertIsFailure<T, E: Equatable>(
        _ result: Result<T, Error>,
        equalTo anError: E,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        assertIsFailure(result) {
            assertEqual($0, anError, file: file, line: line)
        }
    }
    
    /// Comparing any `Errror`to `Equatable` concrete type
    func assertEqual<E: Equatable>(
        _ first: Error,
        _ second: E,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard let element = first as? E else {
            XCTFail("\(first) must be of type \(E.self)", file: file, line: line)
            return
        }
        
        XCTAssertEqual(element, second, file: file, line: line)
    }
}
