//
//  CardsEncodingTests.swift
//
//
//  Created by Hugues Telolahy on 04/11/2023.
//

import Foundation
import Inventory
import XCTest
import Yams

final class CardsEncodingTests: XCTestCase {
    func test_CardList_shouldBeEncodableToJson() throws {
        let model = CardList.all
        let jsonData = try JSONEncoder().encode(model)
        let jsonString = try XCTUnwrap(String(data: jsonData, encoding: .utf8))
        print(jsonString)
    }

    func test_CardList_shouldBeEncodableToYaml() throws {
        let model = CardList.all
        let encoder = YAMLEncoder()
        let yamlString = try encoder.encode(model)
        print(yamlString)
    }
}
