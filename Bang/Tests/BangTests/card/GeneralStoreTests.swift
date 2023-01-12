//
//  GeneralStoreTests.swift
//  
//
//  Created by Hugues Telolahy on 11/01/2023.
//
// swiftlint:disable identifier_name

import XCTest
import Bang

final class GeneralStoreTests: EngineTestCase {
    
    func test_EachPlayerChooseCard_IfPlayingGeneralStore() throws {
        // Given
        let c1 = inventory.getCard("generalStore", withId: "c1")
        let c2 = CardImpl(id: "c2")
        let c3 = CardImpl(id: "c3")
        let c4 = CardImpl(id: "c4")
        let p1 = PlayerImpl(hand: [c1])
        let p2 = PlayerImpl()
        let p3 = PlayerImpl()
        let ctx = GameImpl(players: ["p1": p1, "p2": p2, "p3": p3],
                           playOrder: ["p1", "p2", "p3"],
                           turn: "p1",
                           deck: [c2, c3, c4])
        setupGame(ctx)
        
        // When
        sut.input(Play(actor: "p1", card: "c1"))
        
        // Assert
        try assertSequence([
            .success(Play(actor: "p1", card: "c1")),
            .success(Store()),
            .success(Store()),
            .success(Store()),
            .wait([Choose(player: "p1", label: "c2"),
                   Choose(player: "p1", label: "c3"),
                   Choose(player: "p1", label: "c4")],
                  input: 0),
            .success(Choose(player: "p1", label: "c2")),
            .success(DrawStore(player: PlayerId("p1"), card: CardId("c2"))),
            .wait([Choose(player: "p2", label: "c3"),
                   Choose(player: "p2", label: "c4")],
                  input: 1),
            .success(Choose(player: "p2", label: "c4")),
            .success(DrawStore(player: PlayerId("p2"), card: CardId("c4"))),
            .success(DrawStore(player: PlayerId("p3"), card: CardId("c3")))
        ])
    }
}
