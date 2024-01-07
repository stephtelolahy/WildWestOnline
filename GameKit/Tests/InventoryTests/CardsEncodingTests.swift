//
//  CardsEncodingTests.swift
//
//
//  Created by Hugues Telolahy on 04/11/2023.
//

import Foundation
import Inventory
import XCTest

final class CardsEncodingTests: XCTestCase {
    func test_CardList_shouldBeEncodableToJson() throws {
        let cards = CardList.all
        let jsonData = try JSONEncoder().encode(cards)
        let cardsJsonString = try XCTUnwrap(String(data: jsonData, encoding: .utf8))
        print(cardsJsonString)
    }
}
