//
//  BangTest.swift
//  WildWestOnline
//
//  Created by Stephano Hugues TELOLAHY on 20/10/2024.
//

import Testing
import BangCore

struct Test {
    @Test func playBrown() async throws {
        let action = GameAction.playBrown("c1", player: "p1")

        #expect(action.type == .playBrown)
        #expect(action.payload.actor == "p1")
        #expect(action.payload.card == "c1")
        #expect(String(describing: action) == "🟤 p1 c1")
    }
}
