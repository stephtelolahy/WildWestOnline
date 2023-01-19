//
//  PlayHandicapTests.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//

import XCTest
import Bang

final class PlayHandicapTests: XCTestCase {

    func test_PutInPlayOfTargetPlayer_IfPlayingHandicap() {
        // Given
        let ctx = GameImpl.create(
            PlayerImpl(id: "p1")
                .hand(CardImpl(id: "c1", playMode: PlayHandicap())),
            PlayerImpl(id: "p2"))
        let sut = Play(actor: "p1", card: "c1", target: "p2")
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.player("p1").hand.map(\.id), [])
            XCTAssertEqual(ctx.player("p2").inPlay.map(\.id), ["c1"])
        }
    }

}
