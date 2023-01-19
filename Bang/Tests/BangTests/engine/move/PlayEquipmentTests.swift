//
//  PlayEquipmentTests.swift
//  
//
//  Created by Hugues Telolahy on 19/01/2023.
//

import XCTest
@testable import Bang

final class PlayEquipmentTests: XCTestCase {

    func test_PutInPlay_IfPlayingEquipmentCard() {
        // Given
        let ctx = GameImpl.create(
            PlayerImpl(id: "p1").hand(CardImpl(id: "c1", playMode: PlayEquipment())))
        let sut = Play(actor: "p1", card: "c1")
        
        // When
        let result = sut.resolve(ctx)
        
        // Assert
        assertIsSuccess(result) {
            let ctx = try XCTUnwrap($0.state)
            XCTAssertEqual(ctx.player("p1").hand.map(\.id), [])
            XCTAssertEqual(ctx.player("p1").inPlay.map(\.id), ["c1"])
        }
    }

}
