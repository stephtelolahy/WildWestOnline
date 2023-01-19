//
//  XCTest+Event.swift
//  
//
//  Created by Hugues Telolahy on 10/01/2023.
//

import XCTest
@testable import Bang

extension XCTestCase {
    
    func assertIsSuccess<T: Equatable, E: Error>(
        _ result: Result<Event, E>,
        equalTo aValue: T,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        assertIsSuccess(result) {
            XCTAssertEqual($0 as? T, aValue, file: file, line: line)
        }
    }
    
    /// Comparing any `Event`to `Equatable` concrete type
    public func assertEqual<T: Equatable>(
        _ first: Event,
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
