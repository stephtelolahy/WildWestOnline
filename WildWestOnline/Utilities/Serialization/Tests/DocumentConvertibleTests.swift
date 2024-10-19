//
//  DocumentConvertibleTests.swift
//
//
//  Created by Hugues Telolahy on 13/12/2023.
//

import Serialization
import Testing
import Foundation

struct DocumentConvertibleTests {
    @Test func EncodingToDocument() async throws {
        let document: MyDocument = .init(name: "beer")
        let dictionary: [String: Any] = [
            "name": "beer"
        ]
        #expect(document.dictionary.isEqual(to: dictionary))
    }

    @Test func DecodingFromDocument() async throws {
        let document: MyDocument = .init(name: "beer")
        let dictionary: [String: Any] = [
            "name": "beer"
        ]
        #expect(try MyDocument(dictionary: dictionary) == document)
    }
}

private struct MyDocument: Equatable, Codable, DocumentConvertible {
    let name: String
}

private extension Dictionary where Key == String, Value == Any {
    func isEqual(to other: [String: Any]) -> Bool {
        let lhs = self as NSDictionary
        let rhs = other as NSDictionary
        return lhs == rhs
    }
}
