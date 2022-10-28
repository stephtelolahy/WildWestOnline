//
//  XCTest+Extensions.swift
//  
//
//  Created by TELOLAHY Hugues Stéphano on 28/10/2022.
//
import XCTest

/// Comparing any `Event`to `Equatable` concrete type
public func XCTAssertEqual<T: Equatable>(
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
