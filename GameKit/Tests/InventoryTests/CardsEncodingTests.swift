//
//  CardsEncodingTests.swift
//
//
//  Created by Hugues Telolahy on 04/11/2023.
//

import XCTest
import Foundation
import Inventory
import Yams


final class CardsEncodingTests: XCTestCase {

    func test_CardList_JsonEncoding() throws {
        let model = CardList.all
        let jsonData = try JSONEncoder().encode(model)
        let jsonString = String(data: jsonData, encoding: .utf8)!
        print(jsonString)
    }

    func test_CardList_YamlEncoding() throws {
        let model = CardList.all
        let encoder = YAMLEncoder()
        let yamlString = try encoder.encode(model)
        print(yamlString)
    }

}
