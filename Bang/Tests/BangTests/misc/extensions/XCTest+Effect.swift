//
//  XCTest+Effect.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//
// swiftlint:disable force_cast

import XCTest
import Bang

extension XCTestCase {
    
    func assertIsSuccess<T: Equatable, E: Error>(
        _ result: Result<Effect, E>,
        equalTo aValue: T,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        assertIsSuccess(result) {
            XCTAssertEqual($0 as! T, aValue, file: file, line: line)
        }
    }
    
    /// Comparing any `Effect`to `Equatable` concrete type
    public func assertEqual<T: Equatable>(
        _ first: Effect,
        _ second: T,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        guard let element = first as? T else {
            XCTFail("\(first) must be of type \(T.self)", file: file, line: line)
            return
        }
        
        XCTAssertEqual(element, second, file: file, line: line)
    }
}
