//
//  XCTest+Extensions.swift
//
//
//  Created by TELOLAHY Hugues Stéphano on 02/06/2022.
//

import XCTest

/// Asset equality of any non-equatable array
public func XCTAssertEqual<T: Any>(
    _ first: [T]?,
    _ second: [T],
    file: StaticString = #file,
    line: UInt = #line
) {
    guard let unwrapedFirst = first else {
        XCTFail("Must be not nil", file: file, line: line)
        return
    }
    
    XCTAssertEqual(String(describing: unwrapedFirst), String(describing: second), file: file, line: line)
}

/// Asset equality of any non-equatable dictionary
public func XCTAssertEqual<T: Any>(
    _ first: [String: T],
    _ second: [String: T],
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertEqual(String(describing: first), String(describing: second), file: file, line: line)
}

/// Asset equality of any non-equatable type
public func XCTAssertEqual<T: Any>(
    _ first: T?,
    _ second: T,
    file: StaticString = #file,
    line: UInt = #line
) {
    guard let unwrapedFirst = first else {
        XCTFail("Must be not nil", file: file, line: line)
        return
    }
    
    XCTAssertEqual(String(describing: unwrapedFirst), String(describing: second), file: file, line: line)
}
