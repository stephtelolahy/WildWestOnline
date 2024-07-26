//
//  DocumentConvertibleTests.swift
//
//
//  Created by Hugues Telolahy on 13/12/2023.
//

import Serialization
import XCTest

final class DocumentConvertibleTests: XCTestCase {
    func test_EncodingToDocument() throws {
        let document: MyDocument = .init(name: "beer")
        let dictionary: [String: Any] = [
            "name": "beer"
        ]
        XCTAssertEqual(document.dictionary, dictionary)
    }

    func test_DecodingFromDocument() throws {
        let document: MyDocument = .init(name: "beer")
        let dictionary: [String: Any] = [
            "name": "beer"
        ]
        XCTAssertEqual(try MyDocument(dictionary: dictionary), document)
    }
}

private struct MyDocument: Equatable, Codable, DocumentConvertible {
    let name: String
}
