//
//  XCTAssert+Dictionaries.swift.swift
//  
//
//  Created by Hugues Telolahy on 13/12/2023.
//
// swiftlint:disable legacy_objc_type

import XCTest
public func XCTAssertEqual(
    _ expression1: [String: Any],
    _ expression2: [String: Any],
    _ message: @autoclosure () -> String? = nil,
    file: StaticString = #file,
    line: UInt = #line
) {
    let lhs = expression1 as NSDictionary
    let rhs = expression2 as NSDictionary
    if let msg = message() {
        XCTAssertEqual(lhs, rhs, msg, file: file, line: line)
    } else {
        XCTAssertEqual(lhs, rhs, file: file, line: line)
    }
}
