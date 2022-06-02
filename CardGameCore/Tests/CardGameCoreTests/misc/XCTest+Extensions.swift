//
//  File.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 02/06/2022.
//

import XCTest
@testable import CardGameCore

func XCTAssertEqual<T>(
    _ first: [Result<T>?],
    _ second: [Result<T>?],
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertEqual(String(describing: first), String(describing: second), file: file, line: line)
}

func XCTAssertEqual<T>(
    _ first: Result<T>,
    _ second: Result<T>,
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertEqual(String(describing: first), String(describing: second), file: file, line: line)
}

func XCTAssertEqual<T: Any>(
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

func XCTAssertEqual<T: Any>(
    _ first: Dictionary<String, T>,
    _ second: Dictionary<String, T>,
    file: StaticString = #file,
    line: UInt = #line
) {
    XCTAssertEqual(String(describing: first), String(describing: second), file: file, line: line)
}

func XCTAssertEqual<T: Any>(
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

