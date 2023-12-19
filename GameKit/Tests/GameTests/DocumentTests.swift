//
//  DocumentTests.swift
//
//
//  Created by Hugues Telolahy on 13/12/2023.
//

import Game
import XCTest

final class DocumentTests: XCTestCase {
    func test_EncodingActionToDocument() throws {
        let action: GameAction = .play("beer", player: "p1")
        let dictionary: [String: Any] = [
            "play": [
                "_0": "beer",
                "player": "p1"
            ]
        ]
        XCTAssertEqual(action.dictionary, dictionary)
    }

    func test_DecodingActionFromDocument() throws {
        let action: GameAction = .play("beer", player: "p1")
        let dictionary: [String: Any] = [
            "play": [
                "_0": "beer",
                "player": "p1"
            ]
        ]
        XCTAssertEqual(try GameAction(dictionary: dictionary), action)
    }
}
